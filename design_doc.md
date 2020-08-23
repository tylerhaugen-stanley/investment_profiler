# WIP
  * Living document. Work in progress.
# Adapter
``` ruby
class AlphavantageAdapter:
  @client = Alphavantage::Client.new key: "YOURKEY"

  def stock(symbol)
    stock_client = @client.stock symbol: "MSFT"
    
    Stock.new({
      symbol: symbol,
      income_statements: self.income_statements symbol,
      balance_sheets: self.balance_sheets symbol,
      ...
    })
    
  def income_statements(symbol)
    api_fd = @client.fundamental_data symbol: symbol
    payload = api_fd.income_statements

    # transform data here 
    IncomeStatement({
      fiscalDateEnding: payload.fiscalDateEnding,
      reportedCurrency: payload.reportedCurrency,
      ...
    })
```

# Models
   * Stock
     * Symbol is an ivar.
     * attr_reader for all fields.
   * IncomeStatement
     * Define the internal structure of an income statement. 
     * Initialize needs to take in values for each field.
   * BalanceSheet
   * CashFlow
   * Overview

Need to think about how these aer organized.     


# Class Processor:
   * One processor per application run.
   * Map periods to a standard quarter. IE JAN -> Q1 etc -- ??
  
   ## Methods:
   * processQuarterly(stock)
   * processYearly(stock)
   * All methods to calculate ratios (debt_to_equity, market_cap, ...)

   ## Configs:
   * List of what ratios you want output?
  
  
# Main.rb
  * get symbol list -- from config file?
  * Initialize adapter
  * Initialize processor
  * For each symbol:
    * Create a stock object through the adapter.
    * Ask the data processor to generate the CSV
    * Aggregate all the csv
  * Write the CSV to a file.
    * Need to determine file naming & location. Maybe through configs?
    
# Extra thoughts:
  * Is there a way to write directly to excel? Style the document even?
  
# Future Improvements:
  * Want a way to analyze the data programmatically.
   
  

  
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
  

