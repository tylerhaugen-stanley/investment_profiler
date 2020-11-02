class BalanceSheet < ApplicationRecord

  belongs_to :stock, foreign_key: :stock_id

  validates :stock_id, presence: true
  validates :period, presence: true

  validates_uniqueness_of :fiscal_date_ending, scope: [:stock_id, :period]

  # Use 2 years ago to ensure we get the last 4 since we don't know what date this will be called with.
  # These scopes are ordered most recent quarter to the one from xx months ago.
  scope :last_4, -> (date, period) { where(fiscal_date_ending: 2.years.ago(date)..1.day.since(date), period: period).order(fiscal_date_ending: :desc).limit(4) }
  scope :last_n, -> (date, period, num) { where(fiscal_date_ending: 2.years.ago(date)..1.day.since(date), period: period).order(fiscal_date_ending: :desc).limit(num) }

end
