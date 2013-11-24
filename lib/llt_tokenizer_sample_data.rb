require "llt_tokenizer_sample_data/version"
require 'llt_tokenizer_sample_data/test_files'
require 'llt'

require 'pry'
require 'forwardable'
require 'benchmark_wrapper'

module LltTokenizerSampleData
  class Test
    extend Forwardable
    extend BenchmarkWrapper

    def_delegators :@segmenter, :segment
    def_delegators :@tokenizer, :tokenize

    wrap_with_benchmark :segment, :tokenize

    def initialize
      @files = TestFiles.new
      @segmenter = services.fetch(:segmenter)
      @tokenizer = services.fetch(:tokenizer)
    end

    def services
      LLT::Service
    end

    def run
      # Your inside the Test class.
      # @files, @segmenter and @tokenizer available.
      binding.pry
    end

    def lookup(expr, sentences)
      query = Regexp.new(expr) # a regexp, wheter arg == (Regexp || String)
      indices = sentences.select_indices { |sent| sent.to_s.match(query)}
      indices.map do |i|
        surr_ind = [i - 1, i, i + 1]
        surr_ind.map { |ind| "#{ind}: #{sentences[ind]}" }
      end
    end
  end
end
