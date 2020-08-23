class IncomeStatement

  CLASS_FIELDS = ["cost_of_revenue", "discontinued_operations", "ebit",
                  "effect_of_accounting_charges", "extraordinary_items", "fiscal_date_ending",
                  "gross_profit", "income_before_tax", "income_tax_expense", "interest_expense",
                  "interest_income", "minority_interest", "net_income",
                  "net_income_applicable_to_common_shares",
                  "net_income_from_continuing_operations", "net_interest_income", "non_recurring",
                  "operating_income", "other_items", "other_non_operating_income",
                  "other_operating_expense", "preferred_stock_and_other_adjustments",
                  "reported_currency", "research_and_development",
                  "selling_general_administrative", "tax_provision", "total_operating_expense",
                  "total_other_income_expense", "total_revenue"]

  CLASS_FIELDS.map do |field|
    attr_reader field
  end

  def initialize(data:)
    data.each do |k,v|
      err = "Received a key during initialization that is not supported. Key: #{k}"
      raise IncomeStatementError, err unless CLASS_FIELDS.include?(k.underscore)

      instance_variable_set("@#{k.underscore}", v)
    end
  end
end

class IncomeStatementError < StandardError; end
