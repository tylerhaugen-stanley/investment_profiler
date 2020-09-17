module Adapters
  class AlphaVantage
    def initialize
      @client = Alphavantage::Client.new key: ENV['ALPHAVANTAGE_API_KEY']
    end

    def fetch_data(symbol:)
      @av_fundamental_data = av_fundamental_data(symbol: symbol)
      # This will lookup stock object and load in new data if it exists. If not, create stock
      #   object and then load the data into the DB
      stock = Stock.find_by(symbol: symbol)
      stock = Stock.create({symbol: symbol}) unless stock

      load_balance_sheets(stock_id: stock.id)
      load_cash_flow_statements(stock_id: stock.id)
      load_income_statements(stock_id: stock.id)
      load_overview(stock_id: stock.id)
    end

    private

    def load_balance_sheets(stock_id:)
      av_balance_sheets = @av_fundamental_data.balance_sheets(period: :both)
      ensure_exists(data: av_balance_sheets)

      transform_and_save_reports(
        reports: av_balance_sheets['quarterlyReports'],
        transform_class: BalanceSheet,
        period: :quarterly,
        stock_id: stock_id)

      transform_and_save_reports(
        reports: av_balance_sheets['annualReports'],
        transform_class: BalanceSheet,
        period: :quarterly,
        stock_id: stock_id)
    end

    def load_cash_flow_statements(stock_id:)
      av_cash_flow_statements = @av_fundamental_data.cash_flow_statements(period: :both)
      ensure_exists(data: av_cash_flow_statements)

      transform_and_save_reports(
        reports: av_cash_flow_statements['quarterlyReports'],
        transform_class: CashFlowStatement,
        period: :quarterly,
        stock_id: stock_id)

      transform_and_save_reports(
        reports: av_cash_flow_statements['annualReports'],
        transform_class: CashFlowStatement,
        period: :quarterly,
        stock_id: stock_id)
    end

    def load_income_statements(stock_id:)
      av_income_statements = @av_fundamental_data.income_statements(period: :both)
      ensure_exists(data: av_income_statements)

      transform_and_save_reports(
        reports: av_income_statements['quarterlyReports'],
        transform_class: IncomeStatement,
        period: :quarterly,
        stock_id: stock_id)

      transform_and_save_reports(
        reports: av_income_statements['annualReports'],
        transform_class: IncomeStatement,
        period: :quarterly,
        stock_id: stock_id)
    end

    def load_overview(stock_id:)
      av_overview = @av_fundamental_data.overview
      ensure_exists(data: av_overview)

      transform_and_save_overview(av_overview: av_overview, stock_id: stock_id)
    end

    def time_series(symbol:)
      av_stock = av_stock(symbol: symbol)
      av_time_series_dailies = av_stock.timeseries(type: 'daily',
                                                   outputsize: ENV['TIMESERIES_OUTPUT_SIZE'])
      ensure_exists(data: av_time_series_dailies)

      TimeSeries.new(time_series_dailies:
                       transform_time_series_dailies(av_time_series_dailies: av_time_series_dailies))
    end

    # ---------- Transform methods ----------
    def transform_and_save_reports(reports:, transform_class:, period:, stock_id:)
      reports.each do |report|
        report.transform_keys! { |key| key.underscore.to_sym }
        report.transform_values! do |val|
          begin
            Float(val) # All values are in base thousands.
          rescue
            # Transform any "None" value to nil
            val unless val.downcase == 'none'
          end
        end

        # Add additional fields
        report[:fiscal_date_ending] = Date.parse(report[:fiscal_date_ending])
        report[:period] = period
        report[:stock_id] = stock_id

        transform_class.create(report)
      end
    end

    def transform_and_save_overview(av_overview:, stock_id:)
      # Transform the keys we need to manually change. They must remain strings so that the
      #   following transform works.
      av_ov erview['fifty_two_week_high'] = av_overview.delete('52WeekHigh')
      av_overview['fifty_two_week_low'] = av_overview.delete('52WeekLow')
      av_overview['fifty_day_moving_average'] = av_overview.delete('50DayMovingAverage')
      av_overview['two_hundred_day_moving_average'] = av_overview.delete('200DayMovingAverage')

      # Make sure we make all keys underscore & symbolized after changing any manual ones or else
      #   we can end up with weird keys.
      av_overview.transform_keys! { |key| key.underscore.to_sym }

      # Transform any "None" value to nil
      av_overview.transform_values! do |val|
        begin
          Float(val)
        rescue
          # Transform any "None" value to nil
          val unless val.downcase == 'none'
        end
      end

      # Add additional fields
      av_overview[:latest_quarter] = Date.parse(av_overview[:latest_quarter])
      av_overview[:last_split_date] = Date.parse(av_overview[:last_split_date])
      av_overview[:stock_id] = stock_id

      Overview.create(av_overview)
    end

    # Output:
    # {
    #   date -> TimeSeriesDaily
    # }
    def transform_time_series_dailies(av_time_series_dailies:)
      av_time_series_dailies.output['Time Series (Daily)'].each_with_object({}) do |(date, time_series_daily), hash|
        hash[date.to_date] = TimeSeriesDaily.new(
          date: date.to_date,
          open: time_series_daily['1. open'].to_f,
          high: time_series_daily['2. high'].to_f,
          low: time_series_daily['3. low'].to_f,
          close: time_series_daily['4. close'].to_f,
          volume: time_series_daily['5. volume'].to_i,
        )
      end
    end

    # ---------- Helper methods ----------
    def ensure_exists(data:)
      raise AlphaVantageError if data.nil?
    end

    def av_fundamental_data(symbol:)
      return Adapters::MockAlphaVantage::FundamentalData.new if ENV['ENABLE_MOCK_SERVICES'] == 'true'
      av_fundamental_data = @client.fundamental_data(symbol: symbol)

      av_fundamental_data unless ensure_exists(data: av_fundamental_data)
    end

    def av_stock(symbol:)
      return Adapters::MockAlphaVantage::Stock.new if ENV['ENABLE_MOCK_SERVICES'] == 'true'

      @client.stock(symbol: symbol)
    end
  end
end

class AlphaVantageError < StandardError; end
