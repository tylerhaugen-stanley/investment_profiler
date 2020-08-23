# require_relative '../app/models/overview'

class Main
    args = {
      "Symbol" => "MSFT",
      "AssetType" => "Common Stock",
      "Name"=> "Microsoft Corporation",
      "Description"=> "Microsoftn.",
      "Exchange"=> "NASDAQ",
      "Currency"=> "USD",
      "Country"=> "USA",
      "Sector"=> "Technology",
      "Industry"=> "SoftwareInfrastructure",
      "Address"=> "One Microsoft Way, Redmond, United States, 98052-6399",
      "FullTimeEmployees"=> "163000",
      "FiscalYearEnd"=> "June",
      "LatestQuarter"=> "2020-06-30",
      "MarketCapitalization"=> "1580881936384",
      "EBITDA"=> "65258999808",
      "PERatio"=> "36.2326",
      "PEGRatio"=> "2.4841",
      "BookValue"=> "15.626",
      "DividendPerShare"=> "2.04"}

    test = Overview.new(data: args)
    puts test.symbol

    # api = Adapters::AlphaVantage.new
    # binding.pry
    # stock = api.stock(symbol: "AAPL")
    # binding.pry

  end
