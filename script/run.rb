require "llt_tokenizer_sample_data"

Pry.config.memory_size = 2
LLT::Logger.level = nil
LltTokenizerSampleData::Test.new.run
