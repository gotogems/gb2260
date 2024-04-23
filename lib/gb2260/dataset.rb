module GB2260
  class Dataset
    @@divisions = {}

    def self.keys
      @@divisions.keys
    end

    def self.[](code)
      {
        code: code,
        name: @@divisions[code]
      }
    end

    def self.divisions
      keys.map do |division|
        Division.new(division)
      end
    end
  end
end
