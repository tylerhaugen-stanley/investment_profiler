module Adapters
  class AlphaVantage
    def initialize
      @client = Alphavantage::Client.new key: ENV["ALPHAVANTAGE_API_KEY"]
    end

    def stock(symbol:)
      Stock.new(
        symbol: symbol,
        overview: overview(symbol: symbol),
        # balance_sheets: balance_sheets(symbol: symbol),
        # cash_flow_statements: cash_flow_statements(symbol: symbol),
        # income_statements: income_statements(symbol: symbol),
        # time_series: time_series(symbol: symbol),
      )
    end

    private

    def balance_sheets(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      ensure_exists(data: av_fundamental_data)
      av_balance_sheets = av_fundamental_data.balance_sheets(period: :both)
      ensure_exists(data: av_balance_sheets)

      {
        :quarterly => transform_reports(
                     reports: av_balance_sheets["quarterlyReports"],
                     transform_class: BalanceSheet),
        :annually => transform_reports(
                     reports: av_balance_sheets["annualReports"],
                     transform_class: BalanceSheet),
      }
    end

    def cash_flow_statements(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      ensure_exists(data: av_fundamental_data)
      av_cash_flow_statements = av_fundamental_data.cash_flow_statements(period: :both)
      ensure_exists(data: av_cash_flow_statements)

      {
        :quarterly => transform_reports(
                     reports: av_cash_flow_statements["quarterlyReports"],
                     transform_class: CashFlowStatement),
        :annually => transform_reports(
                     reports: av_cash_flow_statements["annualReports"],
                     transform_class: CashFlowStatement),
      }
    end

    def income_statements(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      ensure_exists(data: av_fundamental_data)
      av_income_statements = av_fundamental_data.income_statements(period: :both)
      ensure_exists(data: av_income_statements)

      {
        :quarterly => transform_reports(
                     reports: av_income_statements["quarterlyReports"],
                     transform_class: IncomeStatement),
        :annually => transform_reports(
                     reports: av_income_statements["annualReports"],
                     transform_class: IncomeStatement),
      }
    end

    def overview(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      ensure_exists(data: av_fundamental_data)
      av_overview = av_fundamental_data.overview
      ensure_exists(data: av_overview)

      transform_overview(av_overview: av_overview)
    end

    def time_series(symbol:)
      av_stock = @client.stock symbol: symbol
      av_time_series = av_stock.timeseries(outputsize: ENV["TIMESERIES_OUTPUT_SIZE"])
      ensure_exists(data: av_time_series)

      TimeSeries.new(time_series_dailies: transform_time_series_dailies(av_time_series: av_time_series))
    end

    # ---------- Transform methods ----------
    def transform_reports(reports:, transform_class:)
      reports.each_with_object({}) do |report, hash|
        report = report.transform_values do |v|
          # Data returned from alpha vantage is base thousands, convert to base millions
          # Need to begin/rescue because the data is returned as strings.
          begin
            Float(v) / 1_000.0
          rescue
            # Transform any "None" value to nil
            v unless v.downcase == "none"
          end
        end

        hash[report["fiscalDateEnding"]] = transform_class.new(data: report)
      end
    end

    def transform_overview(av_overview:)
      unwanted_keys = ["52WeekHigh", "52WeekLow", "50DayMovingAverage", "200DayMovingAverage"]

      Overview.new(data: av_overview.except(*unwanted_keys))
    end

    # Output:
    # {
    #   date -> TimeSeriesDaily
    # }
    def transform_time_series_dailies(av_time_series:)
      av_time_series.output["Time Series (Daily)"].each_with_object({}) do |(date, time_series_daily), hash|
        hash[date.to_date.to_s] = TimeSeriesDaily.new(
          date: date.to_date,
          open: time_series_daily["1. open"].to_f,
          high: time_series_daily["2. high"].to_f,
          low: time_series_daily["3. low"].to_f,
          close: time_series_daily["4. close"].to_f,
          volume: time_series_daily["5. volume"].to_i,
        )
      end
    end

    # ---------- Helper methods ----------
    def ensure_exists(data:)
      raise AlphaVantageError if data.nil?
    end
  end
end

class AlphaVantageError < StandardError; end
