# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_08_184854) do

  create_table "balance_sheets", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.string "period", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "accounts_payable"
    t.integer "accumulated_amortization"
    t.integer "accumulated_depreciation"
    t.integer "additional_paid_in_capital"
    t.integer "capital_lease_obligations"
    t.integer "capital_surplus"
    t.integer "cash"
    t.integer "cash_and_short_term_investments"
    t.integer "common_stock"
    t.integer "common_stock_shares_outstanding"
    t.integer "common_stock_total_equity"
    t.integer "current_long_term_debt"
    t.integer "deferred_long_term_asset_charges"
    t.integer "deferred_long_term_liabilities"
    t.integer "earning_assets"
    t.datetime "fiscal_date_ending"
    t.integer "goodwill"
    t.integer "intangible_assets"
    t.integer "inventory"
    t.integer "liabilities_and_shareholder_equity"
    t.integer "long_term_debt"
    t.integer "long_term_investments"
    t.integer "negative_goodwill"
    t.integer "net_receivables"
    t.integer "net_tangible_assets"
    t.integer "other_assets"
    t.integer "other_current_assets"
    t.integer "other_current_liabilities"
    t.integer "other_liabilities"
    t.integer "other_non_current_liabilities"
    t.integer "other_non_currrent_assets"
    t.integer "other_shareholder_equity"
    t.integer "preferred_stock_redeemable"
    t.integer "preferred_stock_total_equity"
    t.integer "property_plant_equipment"
    t.string "reported_currency"
    t.integer "retained_earnings"
    t.integer "retained_earnings_total_equity"
    t.integer "short_term_debt"
    t.integer "short_term_investments"
    t.integer "total_assets"
    t.integer "total_current_assets"
    t.integer "total_current_liabilities"
    t.integer "total_liabilities"
    t.integer "total_long_term_debt"
    t.integer "total_non_current_assets"
    t.integer "total_non_current_liabilities"
    t.integer "total_permanent_equity"
    t.integer "total_shareholder_equity"
    t.integer "treasury_stock"
    t.integer "warrants"
  end

  create_table "cash_flow_statements", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.string "period", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "capital_expenditures"
    t.integer "cashflow_from_financing"
    t.integer "cashflow_from_investment"
    t.integer "change_in_account_receivables"
    t.integer "change_in_cash"
    t.integer "change_in_cash_and_cash_equivalents"
    t.integer "change_in_exchange_rate"
    t.integer "change_in_inventory"
    t.integer "change_in_liabilities"
    t.integer "change_in_net_income"
    t.integer "change_in_operating_activities"
    t.integer "change_in_receivables"
    t.integer "depreciation"
    t.integer "dividend_payout"
    t.datetime "fiscal_date_ending"
    t.integer "investments"
    t.integer "net_borrowings"
    t.integer "net_income"
    t.integer "operating_cashflow"
    t.integer "other_cashflow_from_financing"
    t.integer "other_cashflow_from_investment"
    t.integer "other_operating_cashflow"
    t.string "reported_currency"
    t.integer "stock_sale_and_purchase"
  end

  create_table "companies", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.string "name"
    t.string "exchange"
    t.string "industry"
    t.string "website"
    t.string "description"
    t.string "ceo"
    t.string "security_name"
    t.string "issue_type"
    t.string "sector"
    t.string "employees"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "income_statements", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.string "period", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cost_of_revenue"
    t.integer "discontinued_operations"
    t.integer "ebit"
    t.integer "effect_of_accounting_charges"
    t.integer "extraordinary_items"
    t.datetime "fiscal_date_ending"
    t.integer "gross_profit"
    t.integer "income_before_tax"
    t.integer "income_tax_expense"
    t.integer "interest_expense"
    t.integer "interest_income"
    t.integer "minority_interest"
    t.integer "net_income"
    t.integer "net_income_applicable_to_common_shares"
    t.integer "net_income_from_continuing_operations"
    t.integer "net_interest_income"
    t.integer "non_recurring"
    t.integer "operating_income"
    t.integer "other_items"
    t.integer "other_non_operating_income"
    t.integer "other_operating_expense"
    t.integer "preferred_stock_and_other_adjustments"
    t.string "reported_currency"
    t.integer "research_and_development"
    t.integer "selling_general_administrative"
    t.integer "tax_provision"
    t.integer "total_operating_expense"
    t.integer "total_other_income_expense"
    t.integer "total_revenue"
  end

  create_table "overviews", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.decimal "analyst_target_price"
    t.string "asset_type"
    t.decimal "beta"
    t.decimal "book_value"
    t.string "country"
    t.string "currency"
    t.string "description"
    t.decimal "diluted_epsttm"
    t.decimal "dividend_date"
    t.decimal "dividend_per_share"
    t.decimal "dividend_yield"
    t.integer "ebitda"
    t.decimal "eps"
    t.decimal "ev_to_ebitda"
    t.decimal "ev_to_revenue"
    t.decimal "ex_dividend_date"
    t.string "exchange"
    t.decimal "fifty_day_moving_average"
    t.decimal "fifty_two_week_high"
    t.decimal "fifty_two_week_low"
    t.decimal "forward_annual_dividend_rate"
    t.string "fiscal_year_end"
    t.decimal "forward_annual_dividend_yield"
    t.decimal "forward_pe"
    t.decimal "full_time_employees"
    t.integer "gross_profit_ttm"
    t.string "industry"
    t.datetime "last_split_date"
    t.string "last_split_factor"
    t.datetime "latest_quarter"
    t.integer "market_capitalization"
    t.string "name"
    t.decimal "operating_margin_ttm"
    t.decimal "payout_ratio"
    t.decimal "pe_ratio"
    t.decimal "peg_ratio"
    t.decimal "percent_insiders"
    t.decimal "percent_institutions"
    t.decimal "price_to_book_ratio"
    t.decimal "price_to_sales_ratio_ttm"
    t.decimal "profit_margin"
    t.decimal "quarterly_earnings_growth_yoy"
    t.decimal "quarterly_revenue_growth_yoy"
    t.decimal "return_on_assets_ttm"
    t.decimal "return_on_equity_ttm"
    t.decimal "revenue_per_share_ttm"
    t.integer "revenue_ttm"
    t.string "sector"
    t.integer "shares_float"
    t.integer "shares_outstanding"
    t.integer "shares_short"
    t.integer "shares_short_prior_month"
    t.decimal "short_percent_float"
    t.decimal "short_percent_outstanding"
    t.decimal "short_ratio"
    t.string "symbol"
    t.decimal "trailing_pe"
    t.decimal "two_hundred_day_moving_average"
  end

  create_table "stats", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.decimal "week_52_change"
    t.decimal "week_52_high"
    t.decimal "week_52_low"
    t.integer "market_cap"
    t.integer "employees"
    t.decimal "day_200_moving_avg"
    t.decimal "day_50_moving_avg"
    t.integer "float"
    t.decimal "avg_10_volume"
    t.decimal "avg_30_volume"
    t.decimal "ttm_eps"
    t.decimal "ttm_dividend_rate"
    t.string "company_name"
    t.integer "shares_outstanding"
    t.decimal "max_change_percent"
    t.decimal "year_5_change_percent"
    t.decimal "year_2_change_percent"
    t.decimal "year_1_change_percent"
    t.decimal "ytd_change_percent"
    t.decimal "month_6_change_percent"
    t.decimal "month_3_change_percent"
    t.decimal "month_1_change_percent"
    t.decimal "day_30_change_percent"
    t.decimal "day_5_change_percent"
    t.datetime "next_dividend_date"
    t.decimal "dividend_yield"
    t.datetime "next_earnings_date"
    t.decimal "pe_ratio"
    t.decimal "beta"
    t.integer "total_cash"
    t.integer "current_debt"
    t.integer "revenue"
    t.integer "gross_profit"
    t.integer "total_revenue"
    t.integer "ebitda"
    t.decimal "revenue_per_share"
    t.decimal "revenue_per_employee"
    t.decimal "debt_to_equity"
    t.decimal "profit_margin"
    t.integer "enterprise_value"
    t.decimal "enterprise_value_to_revenue"
    t.decimal "price_to_sales"
    t.decimal "price_to_book"
    t.decimal "forward_pe_ratio"
    t.decimal "peg_ratio"
    t.decimal "pe_high"
    t.decimal "pe_low"
    t.datetime "week_52_high_date"
    t.datetime "week_52_low_date"
    t.decimal "put_call_ratio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string "symbol", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["symbol"], name: "index_stocks_on_symbol"
  end

  create_table "time_series", force: :cascade do |t|
    t.integer "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "time_series_dailies", force: :cascade do |t|
    t.integer "time_series_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
    t.decimal "open"
    t.decimal "high"
    t.decimal "low"
    t.decimal "close"
    t.integer "volume"
  end

end
