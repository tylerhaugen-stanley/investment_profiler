require_relative './../config/companies'

class Main
  extend Helpers

  headers = [:companies, :date, :price, :return_on_equity, :price_to_earnings, :price_to_book,
             :earnings_per_share, :price_to_earnings_growth, :price_to_sales, :debt_to_equity,
             :market_cap, :retained_earnings, :research_and_development, :dividend_yield,
             :dividend_payout, :gross_margin, :inventory_turnover]


  symbols = Companies.symbols_to_process
  api     = Adapters::AlphaVantage.new
  # builder = Builders::CsvBuilder.new(headers: headers)

  # stock = Stock.first
  # test = stock.get_all_ratios(year: 2019, period: :quarterly)
  # binding.pry

  # Fetch data
  symbols.each do |symbol|
    begin
      api.fetch_data(symbol: symbol)
      # builder.add_stock_data(stock: stock, years: [2020], period: :ttm)
      api_wait(seconds: 60) # TODO This will run one final time even when there are no more symbols to look at.
    rescue StandardError => e
      Rails.logger.error "Unable to gather stock data for #{symbol} - #{e.message}"
      api_wait(seconds: 60) # TODO This will run one final time even when there are no more symbols to look at.
    end
  end
  #
  # symbols.each do |symbol|
  #   begin
  #     stock = api.stock(symbol: symbol)
  #     builder.add_stock_data(stock: stock, years: [2020], period: :ttm)
  #     api_wait(seconds: 60) # TODO This will run one final time even when there are no more symbols to look at.
  #   rescue StandardError => e
  #     Rails.logger.error "Unable to gather stock data for #{symbol} - #{e.message}"
  #     api_wait(seconds: 60) # TODO This will run one final time even when there are no more symbols to look at.
  #   end
  # end


  # begin
  #   builder.build()
  # rescue StandardError => e
  #   Rails.logger.error e.message
  # end


end
