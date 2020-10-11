class IncomeStatement < ApplicationRecord

  belongs_to :stock, foreign_key: :stock_id

  validates :stock_id, presence: true
  validates :period, presence: true

  validates_uniqueness_of :fiscal_date_ending, scope: [:stock_id, :period]

  # Use 2 years ago to ensure we get the last 4 since we don't know what date this will be called with.
  # Also buffer the end date to ensure we get what we expect. Using Date vs DateTime with the date
  # being exactly a quater was resulting in the current quarter not being returned with Date and
  # it being returned with DateTime.
  scope :last_4, -> (date, period) { where(fiscal_date_ending: 2.years.ago(date)..1.day.since(date), period: period).order(fiscal_date_ending: :desc).limit(4) }
  scope :last_n, -> (date, period, num) { where(fiscal_date_ending: 2.years.ago(date)..1.day.since(date), period: period).order(fiscal_date_ending: :desc).limit(num) }

end
