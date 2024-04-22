require 'gb2260/division'
require 'gb2260/version'

module GB2260
  module Utils
    def load_file(path)
      CSV.parse(File.read(path))
    end

    def output_file(filename, string)
      File.open(filename, 'w') do |f|
        f.write(string)
      end
    end
  end
end
