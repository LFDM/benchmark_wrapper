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

      def test1
        1 + 1
      end

      def test2
        2 + 2
      end
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
        dummy.new.test1.should == 2
      end

      it "can wrap multiple methods at once" do
        dummy.wrap_with_benchmark(:test1, :test2)
        obj = dummy.new
        $stdout.should receive(:puts).twice
        obj.test1.should == 2
        obj.test2.should == 4
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
        obj.test1.should == 2
        obj.test2.should == 4
        container.should have(2).items
      end
    end
  end


  after :all do
    $stdout = @stdout
  end
end
