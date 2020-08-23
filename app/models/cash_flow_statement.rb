class CashFlowStatement

  CLASS_FIELDS = ["fiscalDateEnding", "reportedCurrency", "investments", "changeInLiabilities",
                  "cashflowFromInvestment", "otherCashflowFromInvestment", "netBorrowings",
                  "cashflowFromFinancing", "otherCashflowFromFinancing",
                  "changeInOperatingActivities", "netIncome", "changeInCash", "operatingCashflow",
                  "otherOperatingCashflow", "depreciation", "dividendPayout",
                  "stockSaleAndPurchase", "changeInInventory", "changeInAccountReceivables",
                  "changeInNetIncome", "capitalExpenditures", "changeInReceivables",
                  "changeInExchangeRate", "changeInCashAndCashEquivalents"]

  CLASS_FIELDS.map do |field|
    attr_reader field
  end

  def initialize(data:)
    data.each do |k,v|
      err = "Received a key during initialization that is not supported. Key: #{k}"
      raise CashFlowError, err unless CLASS_FIELDS.include?(k.underscore)

      instance_variable_set("@#{k.underscore}", v)
    end
  end
end

class CashFlowError < StandardError; end
