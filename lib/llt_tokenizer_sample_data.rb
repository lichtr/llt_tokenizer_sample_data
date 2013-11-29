require "llt_tokenizer_sample_data/version"
require 'llt_tokenizer_sample_data/test_files'
require 'llt/logger'
require 'llt/segmenter'
require 'llt/tokenizer'

require 'pry'
require 'forwardable'
require 'benchmark_wrapper'
require 'ox'

module LltTokenizerSampleData
  class Test
    extend Forwardable
    extend BenchmarkWrapper

    def_delegators :@segmenter, :segment
    def_delegators :@tokenizer, :tokenize

    def initialize
      @files = TestFiles.new
      @segmenter = LLT::Segmenter.new
      @tokenizer = LLT::Tokenizer.new
    end

    def run
      # Your inside the Test class.
      # @files, @segmenter and @tokenizer available.
      binding.pry
    end

    def segtok(arg)
      txt = arg.kind_of?(Fixnum) ? @files.load(arg) : arg
      sentences = segment(txt)
      sentences.each do |sentence|
        tokenize(sentence.to_s, add_to: sentence)
      end
    end

    def to_xml(arg, output = true)
      # Indirection needed to capture benchmarks without recursion
      recursive_xml(arg, output)
    end

    def recursive_xml(arg, output)
      if arg.kind_of?(Array)
        arg.each { |e| recursive_xml(e, output) }
        nil # don't return the arr
      else
        # Ox is only used for indentation...
        xml = arg.to_xml(recursive: true)
        if output
          doc = Ox.parse(xml)
          puts '-----------------'
          puts arg
          puts Ox.dump(doc, indent: 2).strip
        end
      end
    end

    def lookup(expr, sentences)
      query = Regexp.new(expr) # a regexp, wheter arg == (Regexp || String)
      indices = sentences.select_indices { |sent| sent.to_s.match(query)}
      indices.map do |i|
        surr_ind = [i - 1, i, i + 1]
        surr_ind.map { |ind| "#{ind}: #{sentences[ind]}" }
      end
    end

    wrap_with_benchmark :to_xml #, :segment, :tokenize
  end
end
