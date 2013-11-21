require 'spec_helper'

describe BenchmarkWrapper::Wrapper  do
  let(:wrapper) { BenchmarkWrapper::Wrapper }

  describe "#wrapped_method" do
    it "returns the method new the object has been initialized with" do
      wrapper.new(:a_method)
      wrapper.method.should == :a_method
    end
  end
end
