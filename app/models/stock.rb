class Stock
  attr_reader :symbol, :overview, :balance_sheets, :income_statements, :cash_flow_statements

  def initialize(symbol:, overview: nil, balance_sheets: nil, income_statements: nil, cash_flow_statements: nil)
    @symbol = symbol
    @overview = overview
    @balance_sheets = balance_sheets
    @cash_flow_statements = cash_flow_statements
    @income_statements = income_statements
  end

  def get_all_ratios(date:, period:)
    {
      "return_on_equity" => return_on_equity(date: date, period: period)
    }
  end

  # ---------- Ratio Calculations  ----------
  def return_on_equity(date:, period:)
    # Net income / Average shareholders' equity.
    # income statement || balance sheet
  end

  def price_to_earnings
    # Current stock price / Earnings per share.
  end

  def price_to_book
    # current stock price / Book value per share.
    #
    # book_value per share = (total assets - total liabilities) / number of outstanding shares
  end

  def earnings_per_share
    # net income / number of outstanding shares
  end

  def price_to_earnings_growth
    # price_to_earnings / earnings per share growth (Analyst growth value)
  end

  def price_to_sales
    # current stock price / sales per share
    #
    # sales per share = total revenue / number of outsanding shares.
  end

  def debt_to_equity
    # Total liabilites / total shareholder equity
    #
    # total_shareholder_equity = assets - liabilities
  end

  def market_cap
    # Price per share * number of outstanding shares
  end

  def retained_earnings
    # RE = Beginning Period RE + Net Income/Loss – Cash Dividends – Stock Dividends
    #
    # For us, it's already calcualted on the balance sheet. YAY!
  end

  def research_and_development
    # on the income statement researchAndDevelopment
  end

  def dividend_yield
    # dollar value of dividends paid per share / price per share
  end

  def dividend_payout
    # Dividend paid per share / earnings per share
  end

  def gross_margin
    # net sales - cost of goods sold
  end

  def inventory_turnover
    # sales / average inventory
    #
    # Average Inventory = (Beginning Inventory + Ending Inventory) / 2
  end
end
