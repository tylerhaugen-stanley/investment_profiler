class FixStatsTypos < ActiveRecord::Migration[6.0]
  def change
    remove_column :stats, :nex_dividend_date, :datetime

    rename_column :stats, :next_earningas_date, :next_earnings_date
    rename_column :stats, :prive_to_sales, :price_to_sales
    rename_column :stats, :prive_to_book, :price_to_book
  end
end
