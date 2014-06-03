module Rpx
  class LeaseDate
    attr_reader :value, :coerced

    def initialize(date, coerced=false)
      @coerced = coerced
      @value = transform_date(date)
    end

    def self.coerce(date)
      new(date, true).value
    end

    protected

    def transform_date(date)
      date.to_s
    end
  end
end
