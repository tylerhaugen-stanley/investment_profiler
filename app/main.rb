require_relative './../config/companies'

class Main
  extend Helpers

  SYMBOLS = Companies.symbols_to_process

  def self.fetch_data
    api             = Adapters::AlphaVantage.new
    failed_symbols  = []

    # Fetch data
    SYMBOLS.each do |symbol|
      begin
        puts "Fetching data for: #{symbol}"
        api.fetch_data(symbol: symbol)
        api_wait(seconds: 60) # TODO This will run one final time even when there are no more symbols to look at.
      rescue StandardError => e
        failed_symbols << symbol
        Rails.logger.error "Unable to gather stock data for #{symbol} - #{e.message} \n #{e.backtrace}"
        api_wait(seconds: 60) # TODO This will run one final time even when there are no more symbols to look at.
      end
    end

    puts "**************************** Failed Symbols: #{failed_symbols} ****************************"
  end

  def self.build_csv
    headers = [:companies, :date, :price, :return_on_equity, :price_to_earnings, :price_to_book,
               :earnings_per_share, :price_to_earnings_growth, :price_to_sales, :debt_to_equity,
               :market_cap, :retained_earnings, :research_and_development, :dividend_yield,
               :dividend_payout, :gross_margin, :inventory_turnover]

    builder = Builders::CsvBuilder.new(headers: headers)

    categorized_companies = categorize_companies(companies: SYMBOLS)

    categorized_companies.each do |symbol|
      begin
        stock = Stock.find_by(symbol: symbol)
        builder.add_stock_data(stock: stock, years: [2020], period: :ttm)
      rescue StandardError => e
        Rails.logger.error "Unable to add stock data to csv builder for #{symbol} - #{e.message} \n #{e.backtrace}"
      end
    end

    begin
      builder.build()
    rescue StandardError => e
      Rails.logger.error e.message
    end
  end

  def self.categorize_companies(companies:)

    industry_mapping = {}

    companies.each do |symbol|
      overview = Stock.find_by(symbol: symbol).overviews.newest
      industry = overview.industry

      industry_mapping[industry].append(symbol) if industry_mapping.has_key?(industry)
      industry_mapping[industry] = [symbol] unless industry_mapping.has_key?(industry)
    end

    industry_mapping.values.flatten
  end
end

Main.build_csv
