class Overview

  CLASS_FIELDS = ["Symbol", "AssetType", "Name", "Description", "Exchange", "Currency", "Country",
                  "Sector", "Industry", "Address", "FullTimeEmployees", "FiscalYearEnd",
                  "LatestQuarter", "MarketCapitalization", "EBITDA", "PERatio", "PEGRatio",
                  "BookValue", "DividendPerShare", "DividendYield", "EPS", "RevenuePerShareTTM",
                  "ProfitMargin", "OperatingMarginTTM", "ReturnOnAssetsTTM", "ReturnOnEquityTTM",
                  "RevenueTTM", "GrossProfitTTM", "DilutedEPSTTM", "QuarterlyEarningsGrowthYOY",
                  "QuarterlyRevenueGrowthYOY", "AnalystTargetPrice", "TrailingPE", "ForwardPE",
                  "PriceToSalesRatioTTM", "PriceToBookRatio", "EVToRevenue", "EVToEBITDA", "Beta",
                  # For now don't include these values since we don't need them and attr_reader
                  #   can't start with a number
                  #"52WeekHigh", "52WeekLow", "50DayMovingAverage", "200DayMovingAverage",
                  "SharesOutstanding", "SharesFloat", "SharesShort", "SharesShortPriorMonth",
                  "ShortRatio", "ShortPercentOutstanding", "ShortPercentFloat", "PercentInsiders",
                  "PercentInstitutions", "ForwardAnnualDividendRate", "ForwardAnnualDividendYield",
                  "PayoutRatio", "DividendDate", "ExDividendDate", "LastSplitFactor", "LastSplitDate"]

  CLASS_FIELDS.map do |field|
    attr_reader field
  end

  def initialize(data:)
    data.each do |k,v|
      err = "Received a key during initialization that is not supported. Key: #{k}"
      raise OverviewError, err unless CLASS_FIELDS.include?(k.underscore)

      instance_variable_set("@#{k.underscore}", v)
    end
  end
end

class OverviewError < StandardError; end
