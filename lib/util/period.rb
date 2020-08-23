module Util
  class Period
    attr_reader :period, :number
    def initialize(period, number)
      @period, @number = period, number
    end
  end

  QUARTERLY = "quarterly"
  ANNUALLY = "annually"

  Q1 = Period.new(QUARTERLY, 1)
  Q2 = Period.new(QUARTERLY, 2)
  Q3 = Period.new(QUARTERLY, 3)
  Q4 = Period.new(QUARTERLY, 4)
  AN = Period.new(ANNUALLY, 0)
end
