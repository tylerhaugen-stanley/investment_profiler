class Stock
  attr_reader :symbol, :overview, :balance_sheets, :income_statements, :cash_flow_statements

  def initialize(symbol:, overview: nil, balance_sheets: nil, income_statements: nil, cash_flow_statements: nil)
    @symbol = symbol
    @overview = overview
    @balance_sheets = balance_sheets
    @cash_flow_statements = cash_flow_statements
    @income_statements = income_statements
  end
end
