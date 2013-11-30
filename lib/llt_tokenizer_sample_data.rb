require "llt_tokenizer_sample_data/version"
require 'llt_tokenizer_sample_data/test_files'
require 'llt/logger'
require 'llt/segmenter'
require 'llt/tokenizer'

require 'pry'
require 'forwardable'
require 'benchmark_wrapper'

unless RUBY_PLATFORM == 'java'
  require 'ox'
end

module LltTokenizerSampleData
  class Test
    extend Forwardable
    extend BenchmarkWrapper

    def_delegators :@segmenter, :segment
    def_delegators :@tokenizer, :tokenize

    attr_reader :files, :tokenizer

    def initialize
      @files = TestFiles.new
      @segmenter = LLT::Segmenter.new
      @tokenizer = LLT::Tokenizer.new(indexing: true)
    end

    def run
      # Your inside the Test class.
      # @files, @segmenter and @tokenizer available.
      binding.pry
    end

    def partok(sentences)
      threads = []
      slices = sentences.size / 4 - 1
      sentences.each_slice(slices).each_with_index do |sliced, i|
        threads << Thread.new(i) do
          StemDatabase::Db.connection_pool.with_connection do
            tok = LLT::Tokenizer.new(@tokenizer.default_options)
            sliced.each do |sentence|
              tok.tokenize(sentence.to_s, add_to: sentence)
            end
          end
        end
      end
      threads.each(&:join)
      sentences
    end

    def segtok(arg)
      txt = arg.kind_of?(Fixnum) ? @files.load(arg) : arg
      sentences = segment(txt)
      sentences.each do |sentence|
        tokenize(sentence.to_s, add_to: sentence)
      end
    end

    def to_xml(arg, output = true, args: { tags: [], recursive: true, indexing: true, inline: true})
      if arg.kind_of?(Array)
        arg.each { |e| to_xml(e, output, args: args) }
        nil # don't return the arr
      else
        # Ox is only used for indentation...
        tags = args[:tags].clone
        xml = arg.to_xml(tags, args.reject { |k, _| k == :tags })
        if output
          if args[:inline]
            puts xml
          else
            xml = "<doc>#{xml}</doc>"
            doc = Ox.parse(xml)
            puts '-----------------'
            puts arg
            puts Ox.dump(doc, indent: 2).strip
          end
        end
      end
    end

    def xml_inject(arg, no_ox = false, options = {})
      sentences = segtok(arg)
      xml = sentences.inject('') { |str, s| str << s.to_xml(options) }
      puts Ox.dump(Ox.parse("<doc>#{xml}</doc>"), indent: 2) unless no_ox
    end

    def lookup(expr, sentences)
      query = Regexp.new(expr) # a regexp, wheter arg == (Regexp || String)
      indices = sentences.select_indices { |sent| sent.to_s.match(query)}
      indices.map do |i|
        surr_ind = [i - 1, i, i + 1]
        surr_ind.map { |ind| "#{ind}: #{sentences[ind]}" }
      end
    end

    wrap_with_benchmark :segtok, :partok #, :segment, :tokenize
  end
end
