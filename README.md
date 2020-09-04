# README

## Local Setup
* run `bundle install` to install all dependencies

# Running the app
* For now: `rails runner app/main.rb`

## Using mocks
By default mock reports are turned on through an env var in `.env`

## Using real data
* Create a local file at the root directory called `.env.development.local` and add `ALPHAVANTAGE_API_KEY`. 
If you do not have a key, you can get one for free [here](https://www.alphavantage.co/support/#api-key).
You can use `.env` as a an reference for how to setup your own local secrets file.
* Disable mock reports by adding `ENABKLE_MOCK_SERVICES=FALSE` to your `.env.development.local` file 


# TODO clean this up


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
