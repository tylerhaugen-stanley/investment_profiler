class TimeSeries

  attr_reader :dailies

  def initialize(time_series_dailies:)
    @dailies = time_series_dailies
  end

  def daily(date:)
    @dailies[date]
  end
end
