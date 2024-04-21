module GB2260
  class Division
    attr_reader :name
    attr_reader :type

    def initialize(code)
      @code = code.to_i
      @name = Dataset[code].fetch(:name)
      @type = province? && 'province' or
              prefecture? && 'prefecture' or
              county? && 'county' or 'unknown'
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

    def to_tree
      # toTree(...args: number[]) {
      #   return {
      #     ...this.toJS(),
      #     contents:
      #       this.code === args.shift()
      #         ? this.getChildren().map((division) => division.toTree(...args))
      #         : []
      #   }
      # }
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
