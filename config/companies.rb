# Unable to find: 'KXS', 'US',
module Companies
  def self.symbols_to_process

    list_1 = ['SHOP', 'SNAP', 'AAPL', 'MSFT', 'SNE', 'AMD', 'APRN', 'CVNA', 'CHWY', 'CPRT', 'EBAY',
     'ISRG', 'DXCM', 'ROK', 'MDT', 'TMO', 'GOOG', 'BEP', 'FSLR', 'NEE', 'TWTR',
     'SQ']

    list_2 = [ 'OTEX', 'CNR', 'ADP', 'ACM', 'ALL', 'AJRD', 'AOS', 'ARW', 'AVAV', 'BRKS', 'CERN',
     'COO', 'DIS', 'DOX', 'ETSY', 'FTNT', 'GNRC', 'CRM', 'HD', 'HON', 'IR', 'J', 'LMT', 'MGM',
     'MS', 'AXP', 'V', 'COF', 'MU', 'NOW', 'NVDA', 'OLED', 'OSTK', 'PHM', 'PYPL', 'ROK', 'SBUX',
     'SPLK', 'SWKS', 'TSLA']

    list_3 = ['ROKU', 'SPOT', 'WORK', 'MCD', 'WEN', 'QSR', 'DRI', 'YUM', 'DOCU']

    list_4 = ['CMG', 'MCD', 'SBUX', 'CRM', 'NOW', 'NFLX', 'GOOG', 'MSFT', 'NVDA', 'ISRG', 'TMO', 'DXCM', 'HON', 'ROK', 'BEP', 'NEE', 'BRKS',
              'OLED']

    list_5 = ['ADP', 'ACN', 'VRSN', 'FTNT', 'AKAM', 'CDW', 'ACM', 'PWR', 'EME', 'AIG', 'MET', 'GS', 'TW', 'SCHW']

    list_6 = ['LULU', 'UAA', 'ADS', 'NKE', 'LMND', 'ARKK', 'ARKG', 'COST', 'MP', 'ICLN', 'LAC', 'CLF', 'TRQ', 'PVG', 'HBM', 'NEXA', 'ADBE']

    return list_5 + list_6
    # list_1 + list_2 + list_3 + list_4 + list_5 + list_6
  end
end
