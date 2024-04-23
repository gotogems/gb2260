module GB2260
  class Division
    attr_reader :name
    attr_reader :type

    def initialize(code)
      @code = code.to_i
      @name = Dataset[code][:name]
      @type = province? && 'province' ||
              prefecture? && 'prefecture' ||
              county? && 'county' || 'unknown'
    end

    def parent
      if prefecture?
        Division.new("#{code[0, 2]}0000")
      elsif county?
        Division.new("#{code[0, 4]}00")
      else
        nil
      end
    end

    def children
      Dataset.divisions.select do |division|
        division.parent&.code.eql?(code)
      end
    end

    def province?
      @code.modulo(10_000).zero?
    end

    def prefecture?
      @code.modulo(100).zero? and not province?
    end

    def county?
      @code.modulo(100).positive?
    end

    def code
      @code.to_s
    end

    def to_tree(*args)
      contents = if code.eql?(args.shift)
        children.map { |division| division.to_tree(*args) }
      else
        []
      end

      to_h.merge({ contents: contents })
    end

    def to_h
      {
        code: code,
        name: name,
        type: type
      }
    end
  end
end
