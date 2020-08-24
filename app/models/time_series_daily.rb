class TimeSeriesDaily

  attr_reader :date, :open, :high, :low, :close, :volume

  def initialize(date:, open:, high:, low:, close:, volume:)
    @date = date
    @open = open
    @high = high
    @low = low
    @close = close
    @volume = volume
  end
end
