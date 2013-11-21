# BenchmarkWrapper
[![Build Status](https://travis-ci.org/LFDM/benchmark_wrapper.png)](https://travis-ci.org/LFDM/benchmark_wrapper)
[![Coverage Status](https://coveralls.io/repos/LFDM/benchmark_wrapper/badge.png)](https://coveralls.io/r/LFDM/benchmark_wrapper)
[![Dependency Status](https://gemnasium.com/LFDM/benchmark_wrapper.png)](https://gemnasium.com/LFDM/benchmark_wrapper)

Extend your class to wrap a benchmark around whatever method you want.

## Installation

Add this line to your application's Gemfile:

    gem 'benchmark_wrapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install benchmark_wrapper

## Usage

```ruby
  require 'benchmark_wrapper'

  class A
    extend BenchmarkWrapper
    
    def method1; 1; end

    def method2(arg); arg + yield; end

    wrap_with_benchmark :method1, :method2
  end

  a = A.new

  a.method1
  #  0.000000   0.000000   0.000000 (  0.000010)
  # => 1

  a.method2(1) { 1 }
  #  0.000000   0.000000   0.000000 (  0.000008)
  # => 2
```

It's important to define the methods you want to be benchmarked before
you wrap them. The following will not work:

```ruby
  class A
    extend BenchmarkWrapper

    wrap_with_benchmark :method1
    
    def method1; 1; end
  end
  
  # NameError: undefined method `method1' for class `A'
```

Output defaults to $stdout but can be redirected:

```ruby
  RESULTS = []

  class B
    extend BenchmarkWrapper

    def method1; 1; end
   
    wrap_with_benchmark :method1, out: RESULTS, out_method: :<<
  end

  B.new.method1
  # => 1

  RESULTS
  # => [#<Benchmark::Tms ...>]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
