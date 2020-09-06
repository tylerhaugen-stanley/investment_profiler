class Main
    headers = [:companies, :date, :price, :return_on_equity, :price_to_earnings, :price_to_book,
               :earnings_per_share, :price_to_earnings_growth, :price_to_sales, :debt_to_equity,
               :market_cap, :retained_earnings, :research_and_development, :dividend_yield,
               :dividend_payout, :gross_margin, :inventory_turnover]



    binding.pry
    api = Adapters::AlphaVantage.new
    stock = api.stock(symbol: "TSLA")

    begin
      builder = Builders::CsvBuilder.new(headers: headers)
      builder.add_stock_data(stock: stock, years: [2020], period: :quarterly)
      builder.build()
    rescue StandardError => e
      Rails.logger.error e.message
    end

end
# class Main
#     # binding.pry
#     api = Adapters::AlphaVantage.new
#     # binding.pry
#     stock = api.stock(symbol: "AAPL")
#
#     binding.pry
#
#   end
