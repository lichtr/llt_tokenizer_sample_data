require 'llt_tokenizer_sample_data'
LLT::Logger.level = nil
@test = LltTokenizerSampleData::Test.new

texts = 2.upto(12).map { |i| @test.files.load(i) }.join ' '

def seg(count = 5, texts)
  puts 'segtok'
  count.times { @test.segtok(texts) }
end

def par(count = 5, sentences)
  puts 'partok'
  count.times { @test.partok(sentences) }
end

puts 'Warmup'
seg(3, texts)

puts
puts 'START'
seg(texts)
par(@test.segment(texts))

puts 'Caching enabled'
@test.tokenizer.db.enable_cache

seg(texts)
par(@test.segment(texts))
