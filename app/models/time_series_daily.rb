class TimeSeriesDaily < ActiveRecord::Base

  belongs_to :time_series, foreign_key: :time_series_id

  validates :time_series_id, presence: true
  validates :date, uniqueness:true

  # attr_reader :date, :open, :high, :low, :close, :volume

  # def initialize(date:, open:, high:, low:, close:, volume:)
  #   @date = date
  #   @open = open
  #   @high = high
  #   @low = low
  #   @close = close
  #   @volume = volume
  # end
end
