require './lib/flipkart_api.rb'

api = FlipkartApi.new(ENV["FLIPKART_ID"], ENV["FLIPKART_TOKEN"])
categories = api.get_categories("json")
puts categories
