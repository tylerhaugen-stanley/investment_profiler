class Stock < ApplicationRecord
  include Helpers

  has_many :balance_sheets
  has_many :cash_flow_statements
  has_many :income_statements
  has_many :overviews
  has_many :time_series_dailies, foreign_key: :time_series_id

  has_one :time_series
  has_one :company

  validates :symbol, uniqueness: true, presence: true

  def get_all_ratios(year:, period:)
    ensure_year(year: year)
    ensure_period(period: period)

    # Get the most recent fiscal quarter date from any of the reports saved. Arbitrarily choosing
    # balance sheet
    date = self.balance_sheets.most_recent.fiscal_date_ending
    return [ratios_for_date(date: date, period: :ttm)] if period == :ttm

    # This only works for :quarterly and :annually
    search_dates(year: year, period: period).map do |date|
      ratios_for_date(date: date, period: period)
    end
  end

  # ---------- Ratio Calculations  ----------
  def return_on_equity(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      sum_shareholder_equity = 0

      self.balance_sheets.last_n(date, :quarterly, 5).each do |balance_sheet|
        sum_shareholder_equity += balance_sheet.total_shareholder_equity
      end

      sum_net_income = net_income_ttm(date: date)

      return sum_net_income / (sum_shareholder_equity / 5).to_f
    end

    net_income = net_income(date: date, period: period)
    shareholder_equity = shareholder_equity(date: date, period: period)

    net_income / shareholder_equity
  end

  def price_to_earnings(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    # Stock price does not change based on period and the earnings_per_share function knows
    # how to calculate itself based on period, hence there is no need for specific TTM logic.
    stock_price = stock_price_for_date(date: date)
    eps = earnings_per_share(date: date, period: period)

    stock_price / eps
  end

  def price_to_book(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)
    stock_price = stock_price_for_date(date: date)

    if period == :ttm
      sum_total_assets = 0
      sum_total_liabilities = 0
      num_shares_outstanding_ttm = num_shares_outstanding_ttm(date: date)

      self.balance_sheets.last_4(date, :quarterly).each do |balance_sheet|
        sum_total_assets += balance_sheet.total_assets
        sum_total_liabilities += balance_sheet.total_liabilities
      end

      book_value_ttm = (sum_total_assets - sum_total_liabilities) / num_shares_outstanding_ttm
      return stock_price / book_value_ttm
    end

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

    if period == :ttm
      sum_net_income = net_income_ttm(date: date)
      # Average the num shares outstanding
      sum_average_shares_outstanding = num_shares_outstanding_ttm(date: date) / 4

      return sum_net_income / sum_average_shares_outstanding.to_f
    end

    net_income = net_income(date: date, period: period)
    num_shares_outstanding = num_shares_outstanding(date: date, period: period)

    net_income / num_shares_outstanding
  end

  def price_to_earnings_growth(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    stock_price = stock_price_for_date(date: date)
    eps_ttm = earnings_per_share_last_5(date: date) # Ordered in DESC order.
    eps_ttm_growth = (eps_ttm.first / eps_ttm.last) - 1
    eps_ttm_growth_percent = eps_ttm_growth * 100

    stock_price / eps_ttm.first / eps_ttm_growth_percent
  end

  def price_to_sales(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      total_revenue = total_revenue_ttm(date: date)
      num_shares_outstanding = num_shares_outstanding(date: date, period: :quarterly)
    else
      total_revenue = income_statement_helper(date: date, period: period).total_revenue
      num_shares_outstanding = num_shares_outstanding(date: date, period: period)
    end

    stock_price = stock_price_for_date(date: date)
    revenue_per_share = total_revenue / num_shares_outstanding

    stock_price / revenue_per_share
  end

  def debt_to_equity(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      sum_liabilities = 0
      sum_shareholder_equity = 0

      self.balance_sheets.last_4(date, :quarterly).each do |balance_sheet|
        sum_liabilities += balance_sheet.total_liabilities
        sum_shareholder_equity += balance_sheet.total_shareholder_equity
      end

      return sum_liabilities / sum_shareholder_equity.to_f
    end

    total_liabilities = balance_sheet_helper(date: date, period: period).total_liabilities
    shareholder_equity = shareholder_equity(date: date, period: period)

    total_liabilities / shareholder_equity
  end

  def market_cap(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    stock_price = stock_price_for_date(date: date)
    num_shares_outstanding = num_shares_outstanding(date: date, period: period)

    stock_price * num_shares_outstanding
  end

  def retained_earnings(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      retained_earnings_last_4 = []

      self.balance_sheets.last_4(date, :quarterly).each do |balance_sheet|
        retained_earnings_last_4 << balance_sheet.retained_earnings
      end

      return retained_earnings_last_4.first - retained_earnings_last_4.last
    end


    balance_sheet_helper(date: date, period: period).retained_earnings
  end

  def research_and_development(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      sum_r_and_d = 0

      self.income_statements.last_4(date, :quarterly).each do |income_statement|
        next unless income_statement.research_and_development
        sum_r_and_d += income_statement.research_and_development
      end

      return sum_r_and_d
    end

    income_statement_helper(date: date, period: period).research_and_development
  end

  def dividend_yield(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)
    stock_price = stock_price_for_date(date: date)

    if period == :ttm
      dividend_payout_per_share_ttm = 0

      self.cash_flow_statements.last_4(date, :quarterly).each do |cash_flow_statement|
        next unless cash_flow_statement.dividend_payout

        dividend_payout = cash_flow_statement.dividend_payout.abs
        num_shares_outstanding = num_shares_outstanding(date: cash_flow_statement.fiscal_date_ending, period: :quarterly)

        dividend_payout_per_share_ttm += dividend_payout / num_shares_outstanding
      end

      return dividend_payout_per_share_ttm / stock_price
    end

    dividend_payout = cash_flow_statement_helper(date: date, period: period).dividend_payout&.abs
    return 0 unless dividend_payout

    num_shares_outstanding = num_shares_outstanding(date: date, period: period)
    dividend_payout_per_share = dividend_payout / num_shares_outstanding

    dividend_payout_per_share / stock_price
  end

  def dividend_payout(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      sum_dividend_payout = 0

      self.cash_flow_statements.last_4(date, :quarterly).each do |cash_flow_statement|
        next unless cash_flow_statement.dividend_payout
        sum_dividend_payout += cash_flow_statement.dividend_payout.abs
      end

      return sum_dividend_payout
    end

    cash_flow_statement_helper(date: date, period: period).dividend_payout
  end

  def gross_margin(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      total_revenue_ttm = total_revenue_ttm(date: date)
      cost_of_revenue_ttm = 0

      self.income_statements.last_4(date, :quarterly).each do |income_statement|
        next unless income_statement.cost_of_revenue
        cost_of_revenue_ttm += income_statement.cost_of_revenue.abs
      end

      return (total_revenue_ttm - cost_of_revenue_ttm) / total_revenue_ttm.to_f
    end

    income_statement = income_statement_helper(date: date, period: period)
    cost_of_goods_sold = income_statement.cost_of_revenue
    net_sales = income_statement.total_revenue

    # One of these needs to be a float, arbitrarily picked cost of goods sold.
    net_sales - cost_of_goods_sold.to_f
  end

  def inventory_turnover(date:, period:)
    ensure_date(date: date)
    ensure_period(period: period)

    if period == :ttm
      inventory_ttm = 0
      total_revenue_ttm = total_revenue_ttm(date: date)

      self.balance_sheets.last_4(date, :quarterly).each do |balance_sheet|
        next unless balance_sheet.inventory
        inventory_ttm += balance_sheet.inventory
      end

      return 0 if inventory_ttm == 0
      return total_revenue_ttm / (inventory_ttm / 4)
    end

    total_revenue = income_statement_helper(date: date, period: period).total_revenue
    inventory = balance_sheet_helper(date: date, period: period).inventory
    return 0.0 if inventory.nil?

    total_revenue / inventory
  end

  # ---------- Helpers  ----------

  # Returns a list of sorted dates found within the income statements for the year and period provided
  def search_dates(year:, period:)
    # Income statements, cash flow statements, and balance sheets will all have the same dates
    # within a period. Just use income statements.

    # Sort the dates in DESC order
    self.income_statements.where(period: period).select do |income_statement|
      income_statement.fiscal_date_ending.year == year
    end.pluck(:fiscal_date_ending).sort_by {|a,b| a <=> b }
    # statements.pluck(:fiscal_date_ending).sort_by {|a,b| a <=> b }
  end

  def stock_price_for_date(date:)
    # This is a hack to deal with mock data not having the most recent data if stock_price_for_date
    #   gets called for a date not in the mock data. This is mainly used for creating a TTM ratio
    #   report.
    return nil if date == Date.current && ENV['ENABLE_MOCK_SERVICES'] == 'true'
    stock_price = self.time_series_dailies.find_by(date: date)&.close

    # It is possible that the stock price we are looking for based on the quarterly date is a weekend
    #   To avoid this problem, search for a stock value based on the most recently previous day close
    if stock_price.nil?
      date -= 2.days if date.sunday?
      date -= 1.day if date.saturday?

      stock_price = self.time_series_dailies.find_by(date: date)&.close
      return stock_price unless stock_price.nil?

      # Still unable to find a price for the given day, error out.
      raise StockError, "Unable to find stock price for date: #{date}"
    end

    stock_price
  end

  def ratios_for_date(date:, period:)
    # TODO maybe make a ratios model??
    {
      date.to_date => {
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

  private

  def balance_sheet_helper(date:, period:)
    balance_sheet = self.balance_sheets.find_by(fiscal_date_ending: date, period: period)
    raise StockError, "Unable to find balance sheet for period: #{period} & date: #{date}" if balance_sheet.nil?

    balance_sheet
  end

  def cash_flow_statement_helper(date:, period:)
    cash_flow_statement = self.cash_flow_statements.find_by(fiscal_date_ending: date, period: period)
    raise StockError, "Unable to find cash flow statement for period: #{period} & date: #{date}" if cash_flow_statement.nil?

    cash_flow_statement
  end

  def income_statement_helper(date:, period:)
    income_statement = self.income_statements.find_by(fiscal_date_ending: date, period: period)
    raise StockError, "Unable to find income statement for period: #{period} & date: #{date}" if income_statement.nil?

    income_statement
  end

  def net_income(date:, period:)
    net_income = income_statement_helper(date: date, period: period).net_income
    raise StockError, "Unable to get net income. Period: #{period} & date: #{date}" if net_income.nil?

    net_income.to_f
  end

  def net_income_ttm(date:)
    sum_net_income = 0

    self.income_statements.last_4(date, :quarterly).each do |income_statement|
      sum_net_income += income_statement.net_income
    end

    sum_net_income
  end

  def num_shares_outstanding(date:, period:)
    balance_sheet = balance_sheet_helper(date: date, period: period)
    num_shares_outstanding = balance_sheet.common_stock_shares_outstanding
    raise StockError, "Unable to get num shares outstanding. Period: #{period} & date: #{date}" if num_shares_outstanding.nil?

    num_shares_outstanding.to_f
  end

  # This function will return the average num shares outstanding over a TTM period.
  def num_shares_outstanding_ttm(date:)
    sum_num_shares_outstanding = 0

    self.balance_sheets.last_4(date, :quarterly).each do |balance_sheet|
      sum_num_shares_outstanding += balance_sheet.common_stock_shares_outstanding
    end

    sum_num_shares_outstanding
  end

  def shareholder_equity(date:, period:)
    balance_sheet = balance_sheet_helper(date: date, period: period)
    shareholder_equity = balance_sheet.total_shareholder_equity
    raise StockError, "Unable to get shareholder equity. Period: #{period} & date: #{date}" if shareholder_equity.nil?

    shareholder_equity.to_f
  end

  # This function calculates the EPS for the last 5 quarters INCLUDING the current one.
  # Guaranteed to be sorted in DESC order
  def earnings_per_share_last_5(date:)
    # Determine dates of last 4 quarters, calculate EPS TTM for each one.

    previous_4_quarters = self.income_statements.last_n(date, :quarterly, 5).pluck(:fiscal_date_ending)
    previous_4_quarters.map do |date|
      self.earnings_per_share(date: date, period: :ttm)
    end
  end


  def total_revenue_ttm(date:)
    total_revenue_ttm = 0

    self.income_statements.last_4(date, :quarterly).each do |income_statement|
      total_revenue_ttm += income_statement.total_revenue
    end

    total_revenue_ttm.to_f
  end
end

class StockError < StandardError; end
