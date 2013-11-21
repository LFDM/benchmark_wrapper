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
    it "registers a given method" do
      dummy.wrap_with_benchmark(:a_method)
      container = dummy.instance_variable_get(:@to_be_wrapped_with_benchmark)
      container.should have(1).item
    end

    it "takes several methods at once" do
      dummy.wrap_with_benchmark(:a_method, :other_method)
      container = dummy.instance_variable_get(:@to_be_wrapped_with_benchmark)
      container.should have(2).items
    end
  end

  after :all do
    $stdout = @stdout
  end
end
