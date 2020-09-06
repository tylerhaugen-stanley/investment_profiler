module Builders
  class CsvBuilder
    FILENAME = "./stockdata.csv"

    attr_reader :csv_data

    def initialize(headers:)
      @csv_data = [].append(transform_headers(headers: headers))
      @header_keys = headers
    end

    def add_stock_data(stock:, years:, period:)
      @csv_data << ["#{stock.overview.name} - (#{stock.symbol})"]
      @csv_data << [stock.overview.industry]
      @csv_data << [] # Add blank row

      years.each do |year|
        ratios = stock.get_all_ratios(year: year, period: period)
        ratios.each do |ratio_hash|
          add_row(data: build_ratio_row(ratios: ratio_hash), equal_padding: 1)
        end
      end
    end

    def build()
      CSV.open(FILENAME, "wb") do |csv|
        for row in @csv_data do
          csv << row
        end
      end
      Rails.logger.info "CSV output to file [%s]" % FILENAME
    end

    private

    def build_ratio_row(ratios:)
      # Ratios will only ever be a hash with a single key
      date = ratios.keys.first
      ratio_row = ['', date]

      # Ignore the first two header keys since there are no ratios for those.
      @header_keys[2..].each do |key|
        ratio_row << ratios[date].fetch(key)
      end

      ratio_row
    end

    def add_row(data:, equal_padding: 0)
      append_padding(amount: equal_padding)
      @csv_data.append(data)
      append_padding(amount: equal_padding)
    end

    def blank_row
      []
    end

    # Transform a lowercase symbol into capitzalized words
    def transform_headers(headers:)
      headers.map do |header|
        header.to_s.split('_').map(&:capitalize).join(' ')
      end
    end

    def append_padding(amount:)
      (0...amount).each do |n|
        @csv_data.append(blank_row)
      end
    end
  end
end
