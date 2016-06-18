require './lib/flipkart_api.rb'

api = FlipkartApi.new(ENV["FLIPKART_ID"], ENV["FLIPKART_TOKEN"])
category_products = api.get_products_by_category("bags_wallets_belts")
puts category_products