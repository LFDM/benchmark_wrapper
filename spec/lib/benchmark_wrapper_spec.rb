require 'spec_helper'
require 'stringio'

describe BenchmarkWrapper do
  before :all do
    string_io = StringIO.new
    @stdout = $stdout
    $stdout = string_io
  end

  let(:dummy) do
    Class.new do
      extend BenchmarkWrapper

      def test1; 1; end
      def test2; 2; end
      def test_with_arg(x); 1 + x; end
      def test_with_blk; yield; end
      def test_with_arg_and_blk(x); x + yield; end
    end
  end

  it 'should have a version number' do
    BenchmarkWrapper::VERSION.should_not be_nil
  end

  describe "#wrap_with_benchmark" do
    # Behavior tests
    context 'with the default receiver $stdout' do
      it "wraps a given method with a benchmark" do
        dummy.wrap_with_benchmark(:test1)
        obj = dummy.new
        $stdout.should receive(:puts)
        obj.test1
      end

      it "wrapped methods return their original return value" do
        dummy.wrap_with_benchmark(:test1)
        dummy.new.test1.should == 1
      end

      it "can wrap multiple methods at once" do
        dummy.wrap_with_benchmark(:test1, :test2)
        obj = dummy.new
        $stdout.should receive(:puts).twice
        obj.test1.should == 1
        obj.test2.should == 2
      end
    end

    context 'with a given receiver' do
      it "defers the benchmark result to the given receiver" do
        container = []
        dummy.wrap_with_benchmark(:test1, out: container, out_method: :<<)
        dummy.new.test1
        container.should have(1).item
        container.first.should be_an_instance_of Benchmark::Tms
      end

      it "can wrap multiple methods at once" do
        container = []
        dummy.wrap_with_benchmark(:test1, :test2, out: container, out_method: :<<)
        obj = dummy.new
        obj.test1.should == 1
        obj.test2.should == 2
        container.should have(2).items
      end
    end

    it "doesn't fail when method take arguments" do
      dummy.wrap_with_benchmark(:test_with_arg)
      dummy.new.test_with_arg(0).should == 1
    end

    it "doesn't fail when method takes a block" do
      dummy.wrap_with_benchmark(:test_with_blk)
      dummy.new.test_with_blk { 3 }.should == 3
    end

    it "doesn't fail when method takes argument and block" do
      dummy.wrap_with_benchmark(:test_with_arg_and_blk)
      dummy.new.test_with_arg_and_blk(1) { 4 }.should == 5
    end
  end


  after :all do
    $stdout = @stdout
  end
end
