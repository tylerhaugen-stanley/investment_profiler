class Overview

  CLASS_FIELDS = ["address", "analyst_target_price", "asset_type", "beta", "book_value", "country",
                  "currency", "description", "diluted_epsttm", "dividend_date",
                  "dividend_per_share", "dividend_yield", "ebitda", "eps", "ev_to_ebitda",
                  "ev_to_revenue", "ex_dividend_date", "exchange", "fiscal_year_end",
                  "forward_annual_dividend_rate", "forward_annual_dividend_yield",
                  "forward_pe", "full_time_employees", "gross_profit_ttm", "industry",
                  "last_split_date", "last_split_factor", "latest_quarter",
                  "market_capitalization", "name", "operating_margin_ttm", "payout_ratio",
                  "pe_ratio", "peg_ratio", "percent_insiders", "percent_institutions",
                  "price_to_book_ratio", "price_to_sales_ratio_ttm", "profit_margin",
                  "quarterly_earnings_growth_yoy", "quarterly_revenue_growth_yoy",
                  "return_on_assets_ttm", "return_on_equity_ttm", "revenue_per_share_ttm",
                  "revenue_ttm", "sector", "shares_float", "shares_outstanding", "shares_short",
                  "shares_short_prior_month", "short_percent_float", "short_percent_outstanding",
                  "short_ratio", "symbol", "trailing_pe"]

  # For now don't include these values since we don't need them and attr_reader
                  #   can't start with a number
                  #"52WeekHigh", "52WeekLow", "50DayMovingAverage", "200DayMovingAverage",

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
