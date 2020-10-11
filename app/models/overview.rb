class Overview < ApplicationRecord

  belongs_to :stock, foreign_key: :stock_id

  validates :stock_id, presence: true

  validates_uniqueness_of :latest_quarter, scope: [:stock_id]

end
