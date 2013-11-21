module BenchmarkWrapper
  class Wrapper
    attr_reader :wrapped_method, :out, :out_method

    def initialize(meth, options = { out: $stdout, out_method: :puts })
      @wrapped_method = meth
      @out        = options[:out]
      @out_method = options[:out_method]
    end
  end
end
