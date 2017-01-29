require './lib/flipkart_api.rb'
require 'pry'

describe FlipkartApi do
    before do
      @api = FlipkartApi.new(ENV["FLIPKART_ID"], ENV["FLIPKART_TOKEN"])
      @v1_api = FlipkartApi.new(ENV["FLIPKART_ID"], ENV["FLIPKART_TOKEN"], "v1.1.0")
    end

    describe ".get_categories" do
      it "Will list all the categories" do
        categories = @api.get_categories("json")
        expect(JSON.parse(categories)["apiGroups"]["affiliate"]["apiListings"].size).to be >= 1
      end
    end

    describe ".get_category_porducts_api('bags_wallets_belts')" do
      it "Will get the products rest api for 'bags_wallets_belts' category" do
        product_api = @api.get_category_products_api("bags_wallets_belts")
        expect(product_api).to include "https://affiliate-api.flipkart.net/affiliate/feeds/"
      end

      it "Will get the products rest api 'v1.1.0' for 'bags_wallets_belts' category" do
        product_api = @v1_api.get_category_products_api("bags_wallets_belts")
        expect(product_api).to include "https://affiliate-api.flipkart.net/affiliate/1.0/feeds"
      end
    end

    describe ".get_products_by_category('bags_wallets_belts')" do
      it "Will get the products for 'bags_wallets_belts' category" do
        products = @api.get_products_by_category("bags_wallets_belts")
        expect(products["productInfoList"].size).to be >= 1
      end

      it "Will get the products for 'bags_wallets_belts' category using 'v1.1.0' api" do
        products = @v1_api.get_products_by_category("bags_wallets_belts")
        expect(products["productInfoList"].size).to be >= 1
      end
    end
    
    describe ".get_category_delta_products_api('bags_wallets_belts')" do
      it "Will get the products delts rest api for 'bags_wallets_belts' category" do
        delta_product_api = @api.get_category_delta_products_api('bags_wallets_belts')
        expect(delta_product_api).to include "https://affiliate-api.flipkart.net/affiliate/deltaFeeds/"
      end

      it "Will get the products delta rest api for 'bags_wallets_belts' category" do
        delta_product_api = @v1_api.get_category_delta_products_api('bags_wallets_belts')
        expect(delta_product_api).to include "https://affiliate-api.flipkart.net/affiliate/1.0/deltaFeeds/deepakhb2/category/reh/fromVersion"
      end
    end

    describe ".get_delta_products_by_category('bags_wallets_belts')" do
      it "Will get the products for 'bags_wallets_belts' category" do
        products = @api.get_delta_products_by_category("bags_wallets_belts", 0)
        expect(products["productInfoList"].size).to be >= 1
      end

      it "Will get the products for 'bags_wallets_belts' category using 'v1.1.0' api" do
        products = @v1_api.get_delta_products_by_category("bags_wallets_belts", 0)
        expect(products["productInfoList"].size).to be >= 1
      end
    end

    describe ".get_book_categories" do
      it "Will list all the book categories" do
        categories = @api.get_book_categories("json")
        expect(JSON.parse(categories)["booksCategory"].size).to be >= 1
      end
    end
  
    describe '.get_category_books_api(["Books", "Educational and Professional Books"])' do
      it "Will get the books rest api for 'Educational and Professional Books' category" do
        books_api = @api.get_category_books_api(["Books", "Educational and Professional Books"])
        expect(books_api).to include "https://affiliate-api.flipkart.net/affiliate/1.0/booksFeeds/"
      end
      
      it "Will get the books rest api for 'Books' category" do
        books_api = @api.get_category_books_api(["Books"])
        expect(books_api).to include "https://affiliate-api.flipkart.net/affiliate/1.0/booksFeeds/"
      end
    end
  
    describe '.get_books_by_category(["Books", "Educational and Professional Books"])' do
      it 'will get top 500 selling books for "Educational and Professional Books" category' do
        books = @api.get_books_by_category(["Books","Educational and Professional Books"])
        expect(books["productInfoList"].size).to be >= 1
      end
    end  

#    describe ".get_dotd_offers('json')" do
#      it "Will get all deals of the day offers" do
#        deals = @api.get_dotd_offers("json")
#        expect(deals["dotdList"]).to eq([])
#      end
#    end
  
    describe ".get_top_offers('json')" do
      it "Will get all the top offers" do
        top_offers = @api.get_top_offers("json")
        expect(top_offers["topOffersList"]).to eq([])
      end
    end
  
    describe ".get_product_by_id('MOBDPPZZPXVDJHSQ', 'json')" do
      it "Will get the product" do
        product = @api.get_product_by_id("MOBDPPZZPXVDJHSQ", "json")
        expect(JSON.parse(product)["productBaseInfo"]["productIdentifier"]["productId"]).to eq("MOBDPPZZPXVDJHSQ")
      end
    end
end
