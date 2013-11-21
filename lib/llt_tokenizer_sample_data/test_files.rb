module LltTokenizerSampleData
  class TestFiles
    PATHS = Dir.chdir(File.expand_path('../../../data', __FILE__)) do
      files = Dir.glob('*').sort
      files.map { |file| "#{Dir.pwd}/#{file}" }
    end


    # param arg [String] reg exp look up to load a testfile, takes first hit
    # param arg [Fixnum] load a testfile by array index
    #
    # return [String] the text of a requested file
    def load(arg)
      if path = request_path(arg)
        File.read(path)
      else
        puts 'Invalid filename (#{arg}!)'
        ''
      end
    end

    private

    def request_path(arg)
      if arg.kind_of?(Fixnum)
        PATHS[arg]
      else
        PATHS.find { |p| p.match(/#{arg}/) }
      end
    end
  end
end
