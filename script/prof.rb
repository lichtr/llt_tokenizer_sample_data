require 'llt_tokenizer_sample_data'
require 'perftools'

LLT::Logger.level = nil

def prof(file)
  PerfTools::CpuProfiler.start(file) { yield }
end

@test = LltTokenizerSampleData::Test.new

PATH = File.expand_path('../../profiling', __FILE__)
def f(p)
  PATH + '/' + p
end

def segtok
  prof(f('segtok')) do
    @sentences = 2.upto(12).flat_map { |i| @test.segtok(i) }
  end
end

def xml
  prof(f('xml')) do
    @sentences.each do |s|
      s.to_xml(recursive: true, indexing: true, inline: true)
    end
  end
end

segtok
xml
