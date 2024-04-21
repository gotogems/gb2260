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
      # if (this.isPrefecture) {
      #   return new Division(~~(this.code / 10_000) * 10_000)
      # }
      # if (this.isCounty) {
      #   return new Division(~~(this.code / 100) * 100)
      # }
      # return null
    end

    def children

      # GB2260.divisions.select do |division|
      #   division.parent&.code.eql?(@code)
      # end

      # return Object.keys(gb2260)
      #   .map((code) => new Division(code))
      #   .filter((division) => division.getParent()?.code === this.code)
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
  end
end

#   toTree(...args: number[]) {
#     return {
#       ...this.toJS(),
#       contents:
#         this.code === args.shift()
#           ? this.getChildren().map((division) => division.toTree(...args))
#           : []
#     }
#   }

#   toJS() {
#     return {
#       code: this.code,
#       name: this.name,
#       type: this.type
#     }
#   }
