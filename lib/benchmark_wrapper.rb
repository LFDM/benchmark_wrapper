require "benchmark_wrapper/version"
require "benchmark"

module BenchmarkWrapper
  def wrap_with_benchmark(*meths)
    opts = extract_benchmark_receiver_options(meths)
    out = opts[:out]
    out_method = opts[:out_method]

    meths.each do |meth|
      without_bm, with_bm = wrapper_methods(meth)

      define_method(with_bm) do |*args, &blk|
        # obscenely ugly, but Benchmark class seems
        # to have nothing to avoid this
        ret_val = nil
        Benchmark.bm { ret_val = send(without_bm, *args, &blk) }
        out.send(out_method, bm)
        ret_val
      end

      alias_method without_bm, meth
      alias_method meth, with_bm
    end
  end

  private

  def extract_benchmark_receiver_options(arr)
    opts = arr.last.kind_of?(Hash) ? arr.pop : {}
    default_bm_receiver.merge(opts)
  end

  def default_bm_receiver
    # would love to have this inside a constant,
    # but it would get untestable this way!
    { out: $stdout, out_method: :puts}
  end

  def wrapper_methods(meth)
    ['', 'out'].map do |str|
      "#{meth}_with#{str}_benchmark".to_sym
    end
  end
end
