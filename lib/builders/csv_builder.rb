module Builders
  class CsvBuilder
    FILENAME = "./stockdata.csv"

    attr_reader :csv_data

    def initialize(headers)
      @csv_data = [].append(headers)
      @num_headers = headers.length()
    end

    def add_stock_data(stock, years)
      stock_name_row = [[stock.overview.name]]
      left_row_padding = ["", ""]

      years.each do |year|
        [Util::Q1, Util::Q2, Util::Q3, Util::Q4, Util::AN].each do |period|
          # expects that get_all_ratios returns a flat list
          ratios = left_row_padding + stock.get_all_ratios(period, year)
          stock_name_row.append(ratios)
        end
      end

      add_rows(stock_name_row, blank_row_num: 1)
    end

    def add_row(data, blank_row_num: 0)
      @csv_data.append(data)
      (0...blank_row_num).each do |n|
        @csv_data.append(blank_row)
      end
    end

    def add_rows(data, blank_row_num: 0)
      @csv_data = csv_data + data
      (0...blank_row_num).each do |n|
        @csv_data.append(blank_row)
      end
    end

    def blank_row
      []
    end

    def build()
      CSV.open(FILENAME, "wb") do |csv|
        for row in @csv_data do
          csv << row
        end
      end
      Rails.logger.info "CSV output to file [%s]" % FILENAME
    end
  end
end
