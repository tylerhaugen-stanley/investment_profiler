class Stats < ApplicationRecord

  belongs_to :stock, foreign_key: :stock_id

  validates :stock_id, presence: true

end
