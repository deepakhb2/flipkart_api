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

    describe ".get_category_porducts_api('bags_wallets_belts')" do
      it "Will get the products rest api for 'bags_wallets_belts' category" do
        product_api = @api.get_category_products_api("bags_wallets_belts")
        expect(product_api).to include "https://affiliate-api.flipkart.net/affiliate/feeds/"
      end
    end

    describe ".get_products_by_category('bags_wallets_belts')" do
      it "Will get the products for 'bags_wallets_belts' category" do
        products = @api.get_products_by_category("bags_wallets_belts")
        expect(products["productInfoList"].size).to be > 1
      end
    end

    describe ".get_dotd_offers('json')" do
      it "Will get all deals of the day offers" do
        deals = @api.get_dotd_offers("json")
        expect(deals["dotdList"]).to eq([])
      end
    end
  
    describe ".get_top_offers('json')" do
      it "Will get all the top offers" do
        top_offers = @api.get_top_offers("json")
        expect(top_offers["topOffersList"]).to eq([])
      end
    end
  
    describe ".get_product_by_id('MOBDPPZZPXVDJHSQ', 'json')" do
      it "Will get the product" do
        product = @api.get_product_by_id("MOBDPPZZPXVDJHSQ", "json")
        expect(product["productBaseInfo"]["productIdentifier"]["productId"]).to eq("MOBDPPZZPXVDJHSQ")
      end
    end
end
