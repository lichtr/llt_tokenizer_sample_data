module LltTokenizerSampleData
  class TestFiles
    PATHS = Dir.chdir(File.expand_path('../../../data', __FILE__)) do
      files = Dir.glob('*').sort
      files.map { |file| "#{Dir.pwd}/#{file}" }
    end


    # param arg [String] reg exp look up to load a testfile, takes first hit
    # param arg [Fixnum] load a testfile by array index
    # param arg [Regexp] reg exp look up to load a testfile, takes first hit
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

    def load_all
      names.map do |name|
        load(name)
      end
    end

    def names
      PATHS.map { |path| File.basename(path) }
    end

    private

    def request_path(arg)
      case arg
      when Fixnum then PATHS[arg]
      when Regexp then PATHS.find { |p| p.match(arg)}
      when String then PATHS.find { |p| p.match(/#{arg}/) }
      end
    end

    def self.reload!
      load(__FILE__)
    end
  end
end
