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

  def self.validate_data
    validate_data = {

      # :research_and_development, :inventory, :dividend_payout, :cost_of_revenue

      balance_sheet: [:total_shareholder_equity, :common_stock_shares_outstanding, :total_assets,
                      :total_liabilities, :retained_earnings],
      income_statement: [:net_income, :total_revenue],
      cash_flow_statement: [],
    }

    errors = {}

    SYMBOLS.each do |company|
      stock = Stock.find_by(symbol: company)
      next unless stock
      date = Date.current

      stock.balance_sheets.last_4(date, :quarterly).each do |balance_sheet|
        fields_to_validate = validate_data.fetch(:balance_sheet)
        cur_date = balance_sheet.fiscal_date_ending
        fields_to_validate.each do |field|
          value = balance_sheet.send(field)
          message = "Missing #{field} for #{company} on #{cur_date.to_date} from the balance sheet"

          add_error(errors, message, company) if value.nil?
        end
      end

      stock.income_statements.last_4(date, :quarterly).each do |income_statement|
        fields_to_validate = validate_data.fetch(:income_statement)
        cur_date = income_statement.fiscal_date_ending
        fields_to_validate.each do |field|
          value = income_statement.send(field)
          message = "Missing #{field} for #{company} on #{cur_date.to_date} from the income statement"

          add_error(errors, message, company) if value.nil?
        end
      end

      stock.cash_flow_statements.last_4(date, :quarterly).each do |cash_flow_statement|
        fields_to_validate = validate_data.fetch(:cash_flow_statement)
        cur_date = cash_flow_statement.fiscal_date_ending

        # Validate the the stock price here based on the dates for the last 4 cash flow statements.
        # This could be done in any of the validate loops, randomly use cash flow statements
        begin
          stock_price_for_date = stock.stock_price_for_date(date: cur_date)
        rescue StockError
          message = "missing stock price for #{company} on #{cur_date.to_date}"

          add_error(errors, message, company) if stock_price_for_date.nil?
        end

        fields_to_validate.each do |field|
          value = cash_flow_statement.send(field)
            message = "Missing #{field} for #{company} on #{cur_date.to_date} from the cash flow statement"

          add_error(errors, message, company) if value.nil?
        end
      end
    end

    pp errors
  end

  def self.add_error(errors, msg, company)
    return errors[company] << msg if errors[company]

    errors[company] = [msg]
  end
end

Main.validate_data
