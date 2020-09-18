class TimeSeries < ActiveRecord::Base

  self.table_name = 'time_series'

  belongs_to :stock, foreign_key: :stock_id

  has_many :dailies, class_name: 'TimeSeriesDaily'

  validates :stock_id, uniqueness: true, presence: true

  # def initialize(time_series_dailies:)
  #   @dailies = time_series_dailies
  # end
  #
  # def daily(date:)
  #   @dailies[date]
  # end
end
