class CashFlowStatement < ActiveRecord::Base

  belongs_to :stock, foreign_key: :stock_id

  validates :stock_id, presence: true
  validates :period, presence: true

  validates_uniqueness_of :fiscal_date_ending, scope: [:stock_id, :period]

  # CLASS_FIELDS = ["capital_expenditures", "cashflow_from_financing", "cashflow_from_investment",
  #                 "change_in_account_receivables", "change_in_cash",
  #                 "change_in_cash_and_cash_equivalents", "change_in_exchange_rate",
  #                 "change_in_inventory", "change_in_liabilities", "change_in_net_income",
  #                 "change_in_operating_activities", "change_in_receivables", "depreciation",
  #                 "dividend_payout", "fiscal_date_ending", "investments", "net_borrowings",
  #                 "net_income", "operating_cashflow", "other_cashflow_from_financing",
  #                 "other_cashflow_from_investment", "other_operating_cashflow",
  #                 "reported_currency", "stock_sale_and_purchase"]
  #
  # CLASS_FIELDS.map do |field|
  #   attr_reader field
  # end
  #
  # def initialize(data:)
  #   data.each do |k,v|
  #     err = "Received a key during initialization that is not supported. Key: #{k}"
  #     raise CashFlowError, err unless CLASS_FIELDS.include?(k.underscore)
  #
  #     instance_variable_set("@#{k.underscore}", v.to_f)
  #   end
  # end
end

# class CashFlowError < StandardError; end
