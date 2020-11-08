class AddStatsModel < ActiveRecord::Migration[6.0]
  def change
    create_table :stats do |t|
      t.integer :stock_id, unique: true, null: false

      t.decimal :week_52_change
      t.decimal :week_52_high
      t.decimal :week_52_low
      t.integer :market_cap
      t.integer :employees
      t.decimal :day_200_moving_avg
      t.decimal :day_50_moving_avg
      t.integer :float
      t.decimal :avg_10_volume
      t.decimal :avg_30_volume
      t.decimal :ttm_eps
      t.decimal :ttm_dividend_rate
      t.string :company_name
      t.integer :shares_outstanding
      t.decimal :max_change_percent
      t.decimal :year_5_change_percent
      t.decimal :year_2_change_percent
      t.decimal :year_1_change_percent
      t.decimal :ytd_change_percent
      t.decimal :month_6_change_percent
      t.decimal :month_3_change_percent
      t.decimal :month_1_change_percent
      t.decimal :day_30_change_percent
      t.decimal :day_5_change_percent
      t.datetime :next_dividend_date
      t.decimal :dividend_yield
      t.datetime :next_earningas_date
      t.datetime :nex_dividend_date
      t.decimal :pe_ratio
      t.decimal :beta
      t.integer :total_cash
      t.integer :current_debt
      t.integer :revenue
      t.integer :gross_profit
      t.integer :total_revenue
      t.integer :ebitda
      t.decimal :revenue_per_share
      t.decimal :revenue_per_employee
      t.decimal :debt_to_equity
      t.decimal :profit_margin
      t.integer :enterprise_value
      t.decimal :enterprise_value_to_revenue
      t.decimal :prive_to_sales
      t.decimal :prive_to_book
      t.decimal :forward_pe_ratio
      t.decimal :peg_ratio
      t.decimal :pe_high
      t.decimal :pe_low
      t.datetime :week_52_high_date
      t.datetime :week_52_low_date
      t.decimal :put_call_ratio

      t.timestamps
    end
  end
end
