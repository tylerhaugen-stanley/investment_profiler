class TimeSeries < ApplicationRecord

  self.table_name = 'time_series'

  belongs_to :stock, foreign_key: :stock_id

  has_many :dailies, class_name: 'TimeSeriesDaily'

  validates :stock_id, uniqueness: true, presence: true

end
