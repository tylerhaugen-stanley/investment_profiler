module Adapters
  class IEX
    def initialize
      publishable_token = ENV['IEX_PUBLISHABLE_TOKEN']
      secret_token = ENV['IEX_SECRET_TOKEN']
      endpoint = ENV['IEX_ENDPOINT']

      if ENV['ENABLE_MOCK_SERVICES'] == 'true'
        publishable_token = ENV['IEX_SANDBOX_PUBLISHABLE_TOKEN']
        secret_token = ENV['IEX_SANDBOX_SECRET_TOKEN']
        endpoint = ENV['IEX_SANDBOX_ENDPOINT']
      end

      @client = ::IEX::Api::Client.new(
        publishable_token: publishable_token,
        secret_token: secret_token,
        endpoint: endpoint
      )
    end

    def fetch_data(symbol:)
      # Lookup stock object and load in new data if it exists. If not, create stock
      #   object and then load the data into the DB
      @stock = Stock.find_by(symbol: symbol)
      @stock = Stock.new.tap do |stock|
        stock.symbol = symbol
        stock.time_series = TimeSeries.create({stock_id: stock.id})

        stock.save
      end unless @stock

      load_income_statements(period: :quarter, num: 12)
      # load_income_statements(period: :annual, num: 4)
      load_balance_sheets(period: :quarter, num: 12)
      # load_balance_sheets(period: :annual, num: 4)
      load_cash_flow_statements(period: :quarter, num: 12)
      # load_cash_flow_statements(period: :annual, num: 4)
      load_company
      load_historical_prices
      # load_stats

    end

    def load_historical_prices
      range = historical_prices_range
      historical_prices = @client.historical_prices(@stock.symbol, {range: range})

      historical_prices.each do |historical_price|
        transformed_time_series_daily = {}
        transformed_time_series_daily[:date] = Date.parse(historical_price.date)
        transformed_time_series_daily[:open] = historical_price.u_open
        transformed_time_series_daily[:close] = historical_price.u_close
        transformed_time_series_daily[:high] = historical_price.u_high
        transformed_time_series_daily[:low] = historical_price.u_low
        transformed_time_series_daily[:volume] = historical_price.u_volume

        transformed_time_series_daily[:time_series_id] = @stock.time_series.id

        TimeSeriesDaily.create(transformed_time_series_daily)
      end
    end

    def load_stats
      stats = @client.advanced_stats(@stock.symbol)

      transformed_stats = {}
      transformed_stats[:week_52_change] = stats.week_52_change
      transformed_stats[:week_52_high] = stats.week_52_high
      transformed_stats[:week_52_low] = stats.week_52_low
      transformed_stats[:market_cap] = stats.market_cap
      transformed_stats[:employees] = stats.employees
      transformed_stats[:day_200_moving_avg] = stats.day_200_moving_avg
      transformed_stats[:day_50_moving_avg] = stats.day_50_moving_avg
      transformed_stats[:float] = stats.float
      transformed_stats[:avg_10_volume] = stats.avg_10_volume
      transformed_stats[:avg_30_volume] = stats.avg_30_volume
      transformed_stats[:ttm_eps] = stats.ttm_eps
      transformed_stats[:ttm_dividend_rate] = stats.ttm_dividend_rate
      transformed_stats[:company_name] = stats.company_name
      transformed_stats[:shares_outstanding] = stats.shares_outstanding
      transformed_stats[:max_change_percent] = stats.max_change_percent
      transformed_stats[:year_5_change_percent] = stats.year_5_change_percent
      transformed_stats[:year_2_change_percent] = stats.year_2_change_percent
      transformed_stats[:year_2_change_percent] = stats.year_1_change_percent
      transformed_stats[:ytd_change_percent] = stats.ytd_change_percent
      transformed_stats[:month_6_change_percent] = stats.month_6_change_percent
      transformed_stats[:month_3_change_percent] = stats.month_3_change_percent
      transformed_stats[:month_1_change_percent] = stats.month_1_change_percent
      transformed_stats[:day_30_change_percent] = stats.day_30_change_percent
      transformed_stats[:day_5_change_percent] = stats.day_5_change_percent
      transformed_stats[:next_dividend_date] = stats.next_dividend_date
      transformed_stats[:dividend_yield] = stats.dividend_yield
      transformed_stats[:next_earnings_date] = stats.next_earnings_date
      transformed_stats[:next_dividend_date] = stats.next_dividend_date
      transformed_stats[:pe_ratio] = stats.pe_ratio
      transformed_stats[:beta] = stats.beta
      transformed_stats[:total_cash] = stats.total_cash
      transformed_stats[:current_debt] = stats.current_debt
      transformed_stats[:revenue] = stats.revenue
      transformed_stats[:gross_profit] = stats.gross_profit
      transformed_stats[:total_revenue] = stats.total_revenue
      transformed_stats[:ebitda] = stats.ebitda
      transformed_stats[:revenue_per_share] = stats.revenue_per_share
      transformed_stats[:revenue_per_employee] = stats.revenue_per_employee
      transformed_stats[:debt_to_equity] = stats.debt_to_equity
      transformed_stats[:profit_margin] = stats.profit_margin
      transformed_stats[:enterprise_value] = stats.enterprise_value
      transformed_stats[:enterprise_value_to_revenue] = stats.enterprise_value_to_revenue
      transformed_stats[:price_to_sales] = stats.price_to_sales
      transformed_stats[:price_to_book] = stats.price_to_book
      transformed_stats[:forward_pe_ratio] = stats.forward_pe_ratio
      transformed_stats[:peg_ratio] = stats.peg_ratio
      transformed_stats[:pe_high] = stats.pe_high
      transformed_stats[:pe_low] = stats.pe_low
      transformed_stats[:week_52_high_date] = stats.week_52_high_date
      transformed_stats[:week_52_low_date] = stats.week_52_low_date
      transformed_stats[:put_call_ratio] = stats.put_call_ratio

      transformed_stats[:stock_id] = @stock.id

      Stats.create(transformed_stats)
    end

    def load_company
      return if @stock.company.present?

      company = @client.company(@stock.symbol)

      transformed_company = {}
      transformed_company[:name] = company.company_name
      transformed_company[:exchange] = company.exchange
      transformed_company[:industry] = company.industry
      transformed_company[:website] = company.website
      transformed_company[:description] = company.description
      transformed_company[:ceo] = company.ceo
      transformed_company[:security_name] = company.security_name
      transformed_company[:issue_type] = company.issue_type
      transformed_company[:sector] = company.sector
      transformed_company[:employees] = company.employees

      transformed_company[:stock_id] = @stock.id

      Company.create(transformed_company)
    end

    def load_cash_flow_statements(period:, num:)
      cash_flow_statements = @client.cash_flow(@stock.symbol, {last: num, period: period})

      cash_flow_statements.each do |cash_flow_statement|
        transformed_cash_flow_statement = {}
        transformed_cash_flow_statement[:fiscal_date_ending] = Date.parse(cash_flow_statement.fiscal_date)
        transformed_cash_flow_statement[:net_income] = cash_flow_statement.net_income
        transformed_cash_flow_statement[:depreciation] = cash_flow_statement.depreciation
        transformed_cash_flow_statement[:change_in_receivables] = cash_flow_statement.changes_in_receivables
        transformed_cash_flow_statement[:change_in_inventory] = cash_flow_statement.changes_in_inventories
        transformed_cash_flow_statement[:reported_currency] = cash_flow_statement.currency
        transformed_cash_flow_statement[:change_in_cash] = cash_flow_statement.cash_change
        transformed_cash_flow_statement[:operating_cashflow] = cash_flow_statement.cash_flow
        transformed_cash_flow_statement[:capital_expenditures] = cash_flow_statement.capital_expenditures
        transformed_cash_flow_statement[:investments] = cash_flow_statement.investments
        transformed_cash_flow_statement[:dividend_payout] = cash_flow_statement.dividends_paid
        transformed_cash_flow_statement[:net_borrowings] = cash_flow_statement.net_borrowings
        transformed_cash_flow_statement[:other_cashflow_from_financing] = cash_flow_statement.other_financing_cash_flows
        transformed_cash_flow_statement[:cashflow_from_financing] = cash_flow_statement.cash_flow_financing
        transformed_cash_flow_statement[:other_cashflow_from_investment] = cash_flow_statement.investing_activity_other

        transformed_cash_flow_statement[:period] = transform_period(period: period)
        transformed_cash_flow_statement[:stock_id] = @stock.id

        CashFlowStatement.create(transformed_cash_flow_statement)
      end
    end


    def load_balance_sheets(period:, num:)
      balance_sheets = @client.balance_sheet(@stock.symbol, {last: num, period: period})

      balance_sheets.each do |balance_sheet|
        transformed_balance_sheet = {}
        transformed_balance_sheet[:fiscal_date_ending] = Date.parse(balance_sheet.fiscal_date)
        transformed_balance_sheet[:cash] = balance_sheet.current_cash
        transformed_balance_sheet[:common_stock_shares_outstanding] = balance_sheet.common_stock
        transformed_balance_sheet[:reported_currency] = balance_sheet.currency
        transformed_balance_sheet[:short_term_investments] = balance_sheet.short_term_investments
        transformed_balance_sheet[:net_receivables] = balance_sheet.receivables
        transformed_balance_sheet[:inventory] = balance_sheet.inventory
        transformed_balance_sheet[:other_current_assets] = balance_sheet.other_current_assets
        transformed_balance_sheet[:total_current_assets] = balance_sheet.current_assets
        transformed_balance_sheet[:long_term_investments] = balance_sheet.long_term_investments
        transformed_balance_sheet[:property_plant_equipment] = balance_sheet.property_plant_equipment
        transformed_balance_sheet[:goodwill] = balance_sheet.goodwill
        transformed_balance_sheet[:intangible_assets] = balance_sheet.intangible_assets
        transformed_balance_sheet[:other_assets] = balance_sheet.other_assets
        transformed_balance_sheet[:total_assets] = balance_sheet.total_assets
        transformed_balance_sheet[:accounts_payable] = balance_sheet.accounts_payable
        transformed_balance_sheet[:current_long_term_debt] = balance_sheet.current_long_term_debt
        transformed_balance_sheet[:other_current_liabilities] = balance_sheet.other_current_liabilities
        transformed_balance_sheet[:total_current_liabilities] = balance_sheet.total_current_liabilities
        transformed_balance_sheet[:long_term_debt] = balance_sheet.long_term_debt
        transformed_balance_sheet[:other_liabilities] = balance_sheet.other_liabilities
        transformed_balance_sheet[:total_liabilities] = balance_sheet.total_liabilities
        transformed_balance_sheet[:common_stock] = balance_sheet.common_stock
        transformed_balance_sheet[:retained_earnings] = balance_sheet.retained_earnings
        transformed_balance_sheet[:treasury_stock] = balance_sheet.treasury_stock
        transformed_balance_sheet[:capital_surplus] = balance_sheet.capital_surplus
        transformed_balance_sheet[:total_shareholder_equity] = balance_sheet.shareholder_equity
        transformed_balance_sheet[:net_tangible_assets] = balance_sheet.net_tangible_assets

        transformed_balance_sheet[:period] = transform_period(period: period)
        transformed_balance_sheet[:stock_id] = @stock.id

        BalanceSheet.create(transformed_balance_sheet)
      end
    end

    def load_income_statements(period:, num:)
      income_statements = @client.income(@stock.symbol, {last: num, period: period})

      income_statements.each do |income_statement|
        transformed_income_statement = {}
        transformed_income_statement[:fiscal_date_ending] = Date.parse(income_statement.fiscal_date)
        transformed_income_statement[:total_revenue] = income_statement.total_revenue
        transformed_income_statement[:cost_of_revenue] = income_statement.cost_of_revenue
        transformed_income_statement[:reported_currency] = income_statement.currency
        transformed_income_statement[:gross_profit] = income_statement.gross_profit
        transformed_income_statement[:research_and_development] = income_statement.research_and_development
        transformed_income_statement[:selling_general_administrative] = income_statement.selling_general_and_admin
        transformed_income_statement[:total_operating_expense] = income_statement.operating_expense
        transformed_income_statement[:operating_income] = income_statement.operating_income
        transformed_income_statement[:ebit] = income_statement.ebit
        transformed_income_statement[:interest_income] = income_statement.interest_income
        transformed_income_statement[:income_before_tax] = income_statement.pretax_income
        transformed_income_statement[:income_tax_expense] = income_statement.income_tax
        transformed_income_statement[:minority_interest] = income_statement.minority_interest
        transformed_income_statement[:net_income] = income_statement.net_income
        transformed_income_statement[:net_income_applicable_to_common_shares] = income_statement.net_income_basic

        transformed_income_statement[:period] = transform_period(period: period)
        transformed_income_statement[:stock_id] = @stock.id

        IncomeStatement.create(transformed_income_statement)
      end
    end

    private

    def transform_period(period:)
      return :quarterly if period == :quarter
      :annually if period == :annual
    end

    def historical_prices_range
      # Want to dynamically set the range of data we get for historical prices so that we don't
      # use more credits than we need to.

      # Date being the date for which the time series data is for.
      latest_time_series = @stock.time_series_dailies.most_recent(by: :date)
      return '2y' if latest_time_series.nil?

      diff = (Date.current - latest_time_series.date.to_date).to_i

      case diff
      when 1..30
        '1m'
      when 30..90
        '3m'
      when 90..180
        '6m'
      when 180..360
        '1y'
      when 360..720
        '2y'
      else
        '5y'
      end
    end
  end
end
