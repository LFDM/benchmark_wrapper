module BenchmarkWrapper
  class Wrapper
    attr_reader :wrapped_method, :out, :out_method

    def initialize(meth, out: $stdout, out_method: :puts)
      @wrapped_method = meth
      @out        = out
      @out_method = out_method
    end
  end
end
