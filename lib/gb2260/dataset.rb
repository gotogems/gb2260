module GB2260
  module Dataset
    def self.keys
    end

    def self.load_file(path)
      CSV.parse(File.read(path))
    end
  end
end
