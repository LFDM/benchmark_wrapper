require "benchmark_wrapper/version"

module BenchmarkWrapper
  require "benchmark_wrapper/wrapper"

  def wrap_with_benchmark(*registered_methods)
    @to_be_wrapped_with_benchmark ||= []
    registered_methods.each do |meth|
      @to_be_wrapped_with_benchmark << meth
    end
  end
end
