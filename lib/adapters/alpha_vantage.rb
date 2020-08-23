module Adapters
  class AlphaVantage
    def initialize
      @client = Alphavantage::Client.new key: ENV["ALPHAVANTAGE_API_KEY"]
    end

    def stock(symbol:)
      # alpha_vantage_stock = @client.stock symbol: symbol

      Stock.new(
        symbol: symbol,
        overview: overview(symbol: symbol),
        balance_sheets: balance_sheets(symbol: symbol),
        cash_flow_statements: cash_flow_statements(symbol: symbol),
        income_statements: income_statements(symbol: symbol),
      )
    end

    private

    def balance_sheets(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      av_balance_sheets = av_fundamental_data.balance_sheets(period: :both)

      {
        quarterly: transform_reports(
                     reports: av_balance_sheets["quarterlyReports"],
                     transform_class: BalanceSheet),
        annually: transform_reports(
                     reports: av_balance_sheets["annualReports"],
                     transform_class: BalanceSheet),
      }
    end

    def cash_flow_statements(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      av_cash_flow_statements = av_fundamental_data.cash_flow_statements(period: :both)

      {
        quarterly: transform_reports(
                     reports: av_cash_flow_statements["quarterlyReports"],
                     transform_class: CashFlowStatement),
        annually: transform_reports(
                     reports: av_cash_flow_statements["annualReports"],
                     transform_class: CashFlowStatement),
      }
    end

    def income_statements(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      av_income_statements = av_fundamental_data.income_statements(period: :both)

      {
        quarterly: transform_reports(
                     reports: av_income_statements["quarterlyReports"],
                     transform_class: IncomeStatement),
        annually: transform_reports(
                     reports: av_income_statements["annualReports"],
                     transform_class: IncomeStatement),
      }
    end

    def overview(symbol:)
      av_fundamental_data = @client.fundamental_data(symbol: symbol)
      av_overview = av_fundamental_data.overview

      transform_overview(av_overview)
    end

    # ---------- Transform methods ----------

    def transform_reports(reports:, transform_class:)
      reports.map do |report|
        # Transform any "None" value to nil
        report =report.transform_values { |v| v unless v.downcase == "none" }

        transform_class.new(data: report)
      end
    end

    def transform_overview(overview)
      unwanted_keys = ["52WeekHigh", "52WeekLow", "50DayMovingAverage", "200DayMovingAverage"]

      Overview.new(data: overview.except(*unwanted_keys))
    end
  end
end
