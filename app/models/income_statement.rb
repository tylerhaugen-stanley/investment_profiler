class IncomeStatement

  CLASS_FIELDS = ["fiscalDateEnding", "reportedCurrency", "totalRevenue", "totalOperatingExpense",
                  "costOfRevenue", "grossProfit", "ebit", "netIncome", "researchAndDevelopment",
                  "effectOfAccountingCharges", "incomeBeforeTax", "minorityInterest",
                  "sellingGeneralAdministrative", "otherNonOperatingIncome", "operatingIncome",
                  "otherOperatingExpense", "interestExpense", "taxProvision", "interestIncome",
                  "netInterestIncome", "extraordinaryItems", "nonRecurring", "otherItems",
                  "incomeTaxExpense", "totalOtherIncomeExpense", "discontinuedOperations",
                  "netIncomeFromContinuingOperations", "netIncomeApplicableToCommonShares",
                  "preferredStockAndOtherAdjustments"]

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
