class BalanceSheet

  CLASS_FIELDS = ["fiscalDateEnding", "reportedCurrency", "totalAssets", "intangibleAssets",
                  "earningAssets", "otherCurrentAssets", "totalLiabilities",
                  "totalShareholderEquity", "deferredLongTermLiabilities",
                  "otherCurrentLiabilities", "commonStock", "retainedEarnings", "otherLiabilities",
                  "goodwill", "otherAssets", "cash", "totalCurrentLiabilities", "shortTermDebt",
                  "currentLongTermDebt", "otherShareholderEquity", "propertyPlantEquipment",
                  "totalCurrentAssets", "longTermInvestments", "netTangibleAssets",
                  "shortTermInvestments", "netReceivables", "longTermDebt", "inventory",
                  "accountsPayable", "totalPermanentEquity", "additionalPaidInCapital",
                  "commonStockTotalEquity", "preferredStockTotalEquity",
                  "retainedEarningsTotalEquity", "treasuryStock", "accumulatedAmortization",
                  "otherNonCurrrentAssets", "deferredLongTermAssetCharges",
                  "totalNonCurrentAssets", "capitalLeaseObligations", "totalLongTermDebt",
                  "otherNonCurrentLiabilities", "totalNonCurrentLiabilities", "negativeGoodwill",
                  "warrants", "preferredStockRedeemable", "capitalSurplus",
                  "liabilitiesAndShareholderEquity", "cashAndShortTermInvestments",
                  "accumulatedDepreciation", "commonStockSharesOutstanding"]

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
