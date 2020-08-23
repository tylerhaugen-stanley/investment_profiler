class AlphavantageAdapter:
  @client = Alphavantage::Client.new key: "YOURKEY"

  def stock(symbol)
    stock_client = @client.stock symbol: "MSFT"
    
    intStock.new({
      symbol: symbol,
      income_statements: self.income_statements symbol,
      balance_sheets: self.balance_sheets symbol,
      ...
    })
    
  def income_statements(symbol)
    api_fd = @client.fundamental_data symbol: symbol
    payload = api_fd.income_statements

    # transform data here 
    intIncomeStatement({
      fiscalDateEnding: payload.fiscalDateEnding,
      reportedCurrency: payload.reportedCurrency,
      ...
    })
    

class Stock:

  @symbol

  attr_reader: income_statments [] ??




class Processor:
  # One processor per application run.

  # Map periods to a standard quarter. IE JAN -> Q1 etc
  Methods:
    - processQuarterly(stock)
    - processYearly(stock)

    - All methods to calculate ratios

  # List of what ratios you want output?
  
  def initialize(stock)
    @stock = stock
  
  def debt_to_equity
    equity = stock.income_statement.total_equity
    
    debt / equity
  

  
Main.rb
  require 'csv'
  
  # get stock list from config file?
  # Initialize adapter
  
  for symbol in symbol_list
    stock = AlphavantageAdapter.stock(symbol)
  end
  
  
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
  

