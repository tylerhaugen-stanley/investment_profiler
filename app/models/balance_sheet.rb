class BalanceSheet

  CLASS_FIELDS = ["accounts_payable", "accumulated_amortization", "accumulated_depreciation",
                  "additional_paid_in_capital", "capital_lease_obligations", "capital_surplus",
                  "cash", "cash_and_short_term_investments", "common_stock",
                  "common_stock_shares_outstanding", "common_stock_total_equity",
                  "current_long_term_debt", "deferred_long_term_asset_charges",
                  "deferred_long_term_liabilities", "earning_assets", "fiscal_date_ending",
                  "goodwill", "intangible_assets", "inventory",
                  "liabilities_and_shareholder_equity", "long_term_debt", "long_term_investments",
                  "negative_goodwill", "net_receivables", "net_tangible_assets", "other_assets",
                  "other_current_assets", "other_current_liabilities", "other_liabilities",
                  "other_non_current_liabilities", "other_non_currrent_assets",
                  "other_shareholder_equity", "preferred_stock_redeemable",
                  "preferred_stock_total_equity", "property_plant_equipment", "reported_currency",
                  "retained_earnings", "retained_earnings_total_equity", "short_term_debt",
                  "short_term_investments", "total_assets", "total_current_assets",
                  "total_current_liabilities", "total_liabilities", "total_long_term_debt",
                  "total_non_current_assets", "total_non_current_liabilities",
                  "total_permanent_equity", "total_shareholder_equity", "treasury_stock",
                  "warrants"]

  CLASS_FIELDS.map do |field|
    attr_reader field
  end

  def initialize(data:)
    data.each do |k,v|
      err = "Received a key during initialization that is not supported. Key: #{k}"
      raise BalanceSheetError, err unless CLASS_FIELDS.include?(k.underscore)

      instance_variable_set("@#{k.underscore}", v)
    end
  end
end

class BalanceSheetError < StandardError; end
