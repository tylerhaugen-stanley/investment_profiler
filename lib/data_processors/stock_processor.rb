module DataProcessors
  class StockProcessor
    # todo
    # Need to build out ratio algorithms
    #
    #
    #
    #

    # CSV needs:
    #   Date
    #   Price
    #   * All ratios


    # ---------- Ratio Calculations  ----------
    def return_on_equity
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
end
