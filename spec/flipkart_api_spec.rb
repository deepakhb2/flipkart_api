require './lib/flipkart_api.rb'
require 'pry'

describe FlipkartApi do
    before do
      @api = FlipkartApi.new(ENV["FLIPKART_ID"], ENV["FLIPKART_TOKEN"])
    end

    describe ".get_categories" do
      it "Will list all the categories" do
        categories = @api.get_categories("json")
        expect(JSON.parse(categories)["apiGroups"]["affiliate"]["apiListings"].size).to be > 1
      end
    end

end
