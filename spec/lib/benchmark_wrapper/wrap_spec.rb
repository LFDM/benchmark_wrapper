require 'spec_helper'

describe BenchmarkWrapper::Wrapper  do
  let(:wrapper) { BenchmarkWrapper::Wrapper }

  describe "#wrapped_method" do
    it "returns the method new the object has been initialized with" do
      wrap = wrapper.new(:a_method)
      wrap.wrapped_method.should == :a_method
    end
  end

  describe "#out" do
    describe "returns the object that's used for outputting the bm result" do
      it "it set through an options hash upon initialize" do
        stub = double
        wrap = wrapper.new(:a_method, out: stub)
        wrap.out.should == stub
      end

      it "defaults to $stdout" do
        wrap = wrapper.new(:a_method)
        wrap.out.should == $stdout
      end
    end
  end

  describe "#out_method" do
    describe "returns the method that's used for outputting the bm result" do
      it "it set through an options hash upon initialize" do
        wrap = wrapper.new(:a_method, out_method: :b_method)
        wrap.out_method.should == :b_method
      end

      it "defaults to #puts" do
        wrap = wrapper.new(:a_method)
        wrap.out_method.should == :puts
      end
    end
  end
end
