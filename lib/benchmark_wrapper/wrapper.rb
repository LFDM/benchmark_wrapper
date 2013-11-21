module BenchmarkWrapper
  class Wrapper
    attr_reader :method, :out, :out_method

    def initialize(meth)
      @method = meth

    end
  end
end
