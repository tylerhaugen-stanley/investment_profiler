# README

## Local Setup
* run `bundle install` to install all dependencies

# Running the app
* For now: `rails runner app/main.rb`

# Configuring the data
* Change the companies in `config/companies.rb` and return the appropriate list
* Change the adapter you want to use `app/main.rb:9` for now, will change in the future.

## Using mocks
* By default mock reports are turned on through an env var in `.env`
  * If using IEX data, you will need to configure the sandbox env vars found in `.env.sample`

## Using real data
* Alpha Vantage
    * Create a local file at the root directory called `.env` and add `ALPHAVANTAGE_API_KEY`. 
    * If you do not have a key, you can get one for free [here](https://www.alphavantage.co/support/#api-key).
* IEX
    * Create a new account [here](https://iexcloud.io/) and get your sandbox/production keys.
* You can use `.env.sample` as a an reference for how to setup your own local secrets file.
* Disable mock reports by adding `ENABKLE_MOCK_SERVICES=FALSE` to your `.env` file 
