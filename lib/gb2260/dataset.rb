module GB2260
  class Dataset
    extend Utils
    @@divisions = {}

    def self.[](code)
      {
        code: code,
        name: @@divisions[code.to_s]
      }
    end

    def self.import(csv_file)
      data = load_file(csv_file)
      @@divisions.merge!(data.to_h)
    end

    def self.divisions
      keys.map do |division|
        Division.new(division)
      end
    end

    def self.keys
      @@divisions.keys
    end
  end
end
