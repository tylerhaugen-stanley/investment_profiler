class Stock < ActiveRecord::Base
  # attr_reader :symbol, :overview, :balance_sheets, :income_statements, :cash_flow_statements, :time_series

  include Helpers

  has_many :balance_sheets
  has_many :cash_flow_statements
  has_many :income_statements

  has_many :overviews

  validates :symbol, uniqueness: true, presence: true

  # def initialize(symbol:)
  #   @symbol = symbol
    # @overview = overview
    # @balance_sheets = balance_sheets
    # @cash_flow_statements = cash_flow_statements
    # @income_statements = income_statements
    # @time_series = time_series
  # end

  def get_all_ratios(year:, period:)
    ensure_year(year: year)
    ensure_period(period: period)
    # [
    #   {
    #     return_on_equity,
    #     ...
    #   },
    #   {
    #     return_on_equity,
    #     ...
    #   },
    # ]

    # TODO This date needs to get the stock price on the LatestQuarter date. Assuming that
    #   the overview information is based on the previous quarters numbers.
    return [ratios_for_date(date: Date.current, period: :ttm)] if period == :ttm

    # This only works for :quarterly and :annually
    search_dates(year: year, period: period).map do |date|
      ratios_for_date(date: date, period: period)
    end

  end

  # ---------- Ratio Calculations  ----------
  def return_on_equity(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # Convert value to a percent
    return @overview.return_on_equity_ttm if period == :ttm

    net_income = net_income(date: date, period: period)
    shareholder_equity = shareholder_equity(date: date, period: period)

    net_income / shareholder_equity
  end

  def price_to_earnings(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO is this TTM?
    return @overview.pe_ratio if period == :ttm

    eps = earnings_per_share(date: date, period: period)
    stock_price = stock_price_for_date(date: date)

    stock_price / eps
  end

  def price_to_book(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO is this TTM?
    return @overview.price_to_book_ratio if period == :ttm

    stock_price = stock_price_for_date(date: date)

    balance_sheet = balance_sheet_helper(date: date, period: period)
    total_assets = balance_sheet.total_assets
    total_liabilities = balance_sheet.total_liabilities
    num_shares_outstanding = num_shares_outstanding(date: date, period: period)

    book_value = (total_assets - total_liabilities) / num_shares_outstanding
    stock_price / book_value
  end

  def earnings_per_share(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO is this TTM?
    return @overview.eps if period == :ttm

    net_income = net_income(date: date, period: period)
    num_shares_outstanding = num_shares_outstanding(date: date, period: period)

    net_income / num_shares_outstanding
  end

  def price_to_earnings_growth(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    @overview.peg_ratio # ** This is just for the previous quarter.
    # Maybe use overview.quarterly_earnings_growth_yoy
    # price_to_earnings / earnings per share growth (Analyst growth value)
  end

  def price_to_sales(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    return @overview.price_to_sales_ratio_ttm if period == :ttm

    stock_price = stock_price_for_date(date: date)
    num_shares_outstanding = num_shares_outstanding(date: date, period: period)
    total_revenue = income_statement_helper(date: date, period: period).total_revenue

    sales_per_share = total_revenue / num_shares_outstanding
    stock_price / sales_per_share
  end

  def debt_to_equity(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO no debt to equity for ttm?
    return nil if period == :ttm

    # TODO this calculation is wrong?? Different sites give different numbers for apple's debt to equity
    total_liabilities = balance_sheet_helper(date: date, period: period).total_liabilities
    shareholder_equity = shareholder_equity(date: date, period: period)

    total_liabilities / shareholder_equity
  end

  def market_cap(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO is this TTM?
    return @overview.market_capitalization if period == :ttm

    stock_price = stock_price_for_date(date: date)
    num_shares_outstanding = num_shares_outstanding(date: date, period: period)

    stock_price * num_shares_outstanding
  end

  def retained_earnings(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO no retained earnings for ttm?
    return nil if period == :ttm

    balance_sheet = balance_sheet_helper(date: date, period: period)

    balance_sheet.retained_earnings
  end

  def research_and_development(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO no R&D for ttm?
    return nil if period == :ttm

    income_statement = income_statement_helper(date: date, period: period)
    income_statement.research_and_development
  end

  def dividend_yield(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO is this TTM?
    return @overview.dividend_yield if period == :ttm

    nil # TODO
    # dollar value of dividends paid per share / price per share
  end

  def dividend_payout(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # TODO no dividend payout for ttm?
    return nil if period == :ttm

    cash_flow_statement = cash_flow_statement_helper(date: date, period: period)

    cash_flow_statement.dividend_payout
  end

  def gross_margin(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    nil # TODO
    # cogs = cost_of_revenue
    #
    # net_sales = total_revenue
    # net sales - cost of goods sold
  end

  def inventory_turnover(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    return nil if period == :ttm

    income_statement = income_statement_helper(date: date, period: period)
    balance_sheet = balance_sheet_helper(date: date, period: period)
    cost_of_revenue = income_statement.cost_of_revenue
    inventory = balance_sheet.inventory

    cost_of_revenue / inventory
  end

  private

  # ---------- Helpers  ----------

  # Returns a list of sorted dates found within the income statements for the year and period provided
  def search_dates(year:, period:)
    # Income statements, cash flow statements, and balance sheets will all have the same dates
    # within a period. Just use income statements.

    # Sort the dates in DESC order
    @income_statements[period].keys.filter {|date| date.year == year}.sort_by {|a,b| a <=> b}
  end

  def stock_price_for_date(date:)
    # This is a hack to deal with mock data not having the most recent data if stock_price_dor_date
    #   gets called for a date not in the mock data. This is mainly used for creating a TTM ratio
    #   report.
    return nil if date == Date.current && ENV["ENABLE_MOCK_SERVICES"] == "true"
    stock_price = @time_series&.daily(date: date)&.close

    # It is possible that the stock price we are looking for based on the quarterly date is a weekend
    #   To avoid this problem, search for a stock value based on the most recently previous day close
    if stock_price.nil?
      date -= 2.days if date.sunday?
      date -= 1.day if date.saturday?

      stock_price = @time_series&.daily(date: date)&.close
      return stock_price unless stock_price.nil?

      # Still unable to find a price for the given day, error out.
      raise StockError, "Unable to find stock price for date: #{date}"
    end

    stock_price
  end

  def ratios_for_date(date:, period:)
    {
      date => {
        :price => stock_price_for_date(date: date),
        :return_on_equity => return_on_equity(date: date, period: period),
        :price_to_earnings => price_to_earnings(date: date, period: period),
        :price_to_book => price_to_book(date: date, period: period),
        :earnings_per_share => earnings_per_share(date: date, period: period),
        :price_to_earnings_growth => price_to_earnings_growth(date: date, period: period),
        :price_to_sales => price_to_sales(date: date, period: period),
        :debt_to_equity => debt_to_equity(date: date, period: period),
        :market_cap => market_cap(date: date, period: period),
        :retained_earnings => retained_earnings(date: date, period: period),
        :research_and_development => research_and_development(date: date, period: period),
        :dividend_yield => dividend_yield(date: date, period: period),
        :dividend_payout => dividend_payout(date: date, period: period),
        :gross_margin => gross_margin(date: date, period: period),
        :inventory_turnover => inventory_turnover(date: date, period: period),
      }
    }
  end

  def balance_sheet_helper(date:, period:)
    balance_sheet = @balance_sheets.dig(period, date)
    raise StockError, "Unable to find balance sheet for period: #{period} & date: #{date}" if balance_sheet.nil?

    balance_sheet
  end

  def cash_flow_statement_helper(date:, period:)
    cash_flow_statement = @cash_flow_statements.dig(period, date)
    raise StockError, "Unable to find cash flow statement for period: #{period} & date: #{date}" if cash_flow_statement.nil?

    cash_flow_statement
  end

  def income_statement_helper(date:, period:)
    income_statement = @income_statements.dig(period, date)
    raise StockError, "Unable to find income statement for period: #{period} & date: #{date}" if income_statement.nil?

    income_statement
  end

  def net_income(date:, period:)
    net_income = income_statement_helper(date: date, period: period).net_income
    raise StockError, "Unable to get net income. Period: #{period} & date: #{date}" if net_income.nil?

    net_income
  end

  def num_shares_outstanding(date:, period:)
    balance_sheet = balance_sheet_helper(date: date, period: period)
    num_shares_outstanding = balance_sheet.common_stock_shares_outstanding
    raise StockError, "Unable to get num shares outstanding. Period: #{period} & date: #{date}" if num_shares_outstanding.nil?

    num_shares_outstanding
  end

  def shareholder_equity(date:, period:)
    balance_sheet = balance_sheet_helper(date: date, period: period)
    shareholder_equity = balance_sheet.total_shareholder_equity
    raise StockError, "Unable to get shareholder equity. Period: #{period} & date: #{date}" if shareholder_equity.nil?

    shareholder_equity
  end
end

class StockError < StandardError; end
