module Adapters
  module MockAlphaVantage

    class FundamentalData
      def overview
        file = File.open('./test/mock_data/overview.json')
        overview = Oj.load(file)
        file.close

        overview
      end

      def income_statements(period:)
        file = File.open('./test/mock_data/income_statements.json')
        income_statements = Oj.load(file)
        file.close

        income_statements
      end

      def cash_flow_statements(period:)
        file = File.open('./test/mock_data/cash_flow_statements.json')
        cash_flow_statements = Oj.load(file)
        file.close

        cash_flow_statements
      end

      def balance_sheets(period:)
        file = File.open('./test/mock_data/balance_sheets.json')
        balance_sheets = Oj.load(file)
        file.close

        balance_sheets
      end
    end

    class Stock

      def timeseries(type:, outputsize:)
        file = File.open('./test/mock_data/time_series_daily.json') if outputsize == 'compact'
        file = File.open('./test/mock_data/time_series_daily_full.json') if outputsize == 'full'
        time_series = Oj.load(file)
        file.close

        OpenStruct.new(:output => time_series)
      end
    end
  end
end
