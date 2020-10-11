class TimeSeriesDaily < ApplicationRecord

  belongs_to :time_series, foreign_key: :time_series_id

  validates :time_series_id, presence: true
  # validates :date, uniqueness:true
  validates_uniqueness_of :date, scope: [:time_series_id]

end
