require "llt_tokenizer_sample_data/version"
require 'llt_tokenizer_sample_data/test_files'
require 'llt'

require 'pry'
require 'forwardable'

module LltTokenizerSampleData
  class Test
    extend Forwardable

    def_delegators :@segmenter, :segment
    def_delegators :@tokenizer, :tokenize

    def initialize
      @files = TestFiles.new
      @segmenter = services.fetch(:segmenter)
      @tokenizer = services.fetch(:tokenizer)
    end

    def services
      LLT::Service
    end

    def run
      binding.pry
    end
  end
end
