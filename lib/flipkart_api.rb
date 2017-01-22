# coding: utf-8
require "rest-client"
require "pry"
require "logger"

class FlipkartApi

  ##
  #
  # Initialize object with userid and token to send api calls.
  #
  def initialize(fk_userid, fk_token, version='v0.1.0')
    @api = "https://affiliate-api.flipkart.net/affiliate"
    @header = {"Fk-Affiliate-Id" => fk_userid, "Fk-Affiliate-Token" => fk_token}
    @version = version
  end
 
  ##
  #
  # This method will get all the categories list in flipkart with rest url to access products
  # of that particular category in json or xml format. ("json"/"xml")
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_categories("json")
  #
  def get_categories(format)
    rest_url="#{@api}/api/#{@header['Fk-Affiliate-Id']}.#{format}"
    RestClient.get rest_url, @header
  end

  ##
  #
  # This method will get the api for accessing all the products of a particular category.
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_category_porducts_api("bags_wallets_belts")
  # Returns the api to get all the products of the category
  #
  def get_category_products_api(category)
    JSON.parse(get_categories("json"))["apiGroups"]["affiliate"]["apiListings"][category]["availableVariants"][@version]["get"]
  end

  ##
  #
  # This method will get the api for accessing all the products of a particular category.
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_category_delta_porducts_api("bags_wallets_belts")
  # Returns the api to get all the products of the category
  #
  def get_category_delta_version_api(category)
    JSON.parse(get_categories("json"))["apiGroups"]["affiliate"]["apiListings"][category]["availableVariants"][@version]["deltaGet"]
  end

  def get_current_delta_version(version_api)
    JSON.parse(RestClient.get(version_api, @header))['version']
  end
  
  def get_category_delta_products_api(category, version=nil)
    version_api = get_category_delta_version_api(category)
    version = get_current_delta_version(version_api) unless version
    version_api.gsub(".json","/fromVersion/#{version}.json")
  end

  ##
  #
  # This method will get the first 500 products in the json parsed data structure.
  # Output will also contain "nextUrl" which inturn returns next 500 products.
  # Usage:
  #  * fa.get_products_by_category("bags_wallets_belts")
  #
  def get_products_by_category(category)
    get_products(get_category_products_api(category))
  end
 
  ##
  #
  # This method will get the first 500 products in the json parsed data structure.
  # Output will also contain "nextUrl" which inturn returns next 500 products.
  # Usage:
  #  * fa.get_delta_products_by_category("bags_wallets_belts")
  #
  def get_delta_products_by_category(category, version=nil)
    get_products(get_category_delta_products_api(category, version))
  end 
  ##
  #
  # This method will get all the products in the json parsed data structure.
  # The parameter is the output of get_category_products_api("bags_wallets_belts")
  # Usage:
  #  * fa.get_all_products(rest_url)
  #
  def get_all_products(rest_url)
    json_arr = []
    json_data = get_products rest_url
    json_arr << [json_data]
    while json_data["nextUrl"]
      json_data = get_products json_data["nextUrl"]
      json_arr << [json_data]
    end
    jsonout = json_arr.to_json
  end

  ##
  #
  # This method will get the first 500 products from the given rest api in the json parsed data structure.
  # Usage:
  #  * fa.get_products(rest_url)
  #
  def get_products(rest_url)
    rest_output = RestClient.get rest_url, @header
    json_data = JSON.parse(rest_output)
  end
  
  ##
  #
  # This method will get all the categories list in flipkart with rest url to access books
  # of that particular category in json or xml format. ("json"/"xml")
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_books_categories("json")
  # 
  def get_book_categories(format)
    rest_url="#{@api}/1.0/booksApi/#{@header['Fk-Affiliate-Id']}.#{format}"
    RestClient.get rest_url, @header
  end
  
  ##
  #
  # This method will get the api for accessing books of a particular category.
  # Since flipkart returns categories in tree structure. This method takes parameter in array to find the category in parent child order.
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_category_books_api(["books", "Fiction & Non-Fiction Books", "Children Books"])
  # Returns the api to get bookds of the category
  #
  def get_category_books_api(categories)
    json_categories = JSON.parse(get_book_categories("json"))["booksCategory"]
    return json_categories["url"] if categories.size==1 && categories.first=="Books"
    categories.drop(1).inject(json_categories){|json_categories, category| json_categories["subCategories"].select{|sub_category| sub_category["name"]==category}.first}["url"]
  end
  
  ##
  #
  # This method will get the first 500 books from the given category in the json parsed data structure.
  # Usage:
  #  * fa.get_books_by_category(["Books", "Fiction & Non-Fiction Books", "Children Books", "Activity Books", "Cursive Writing"])
  # Returns the books from 'Cursive Writing' category
  #
  def get_books_by_category(categories)
    rest_output = RestClient.get get_category_books_api(categories), @header
    JSON.parse(rest_output)
  end
  
  ##
  #
  # This method will get the deals of the day in json or xml format.
  # Usage:
  #  * fa.get_dotd_offes("json")  Can accept "xml" .
  # 
  # Output
  # Details on dotdList:
  #  * title - Title of the offer
  #  * description - Description about the offer
  #  * url - URL for the offer
  #  * imageUrls - List of Image URLs corresponding to the Offer
  #  * availability - Either “In-stock” / “Out-of-stock” about the products with offer.
  #
  def get_dotd_offers(format)
    rest_url = "#{@api}/offers/v1/dotd/#{format}"
    JSON.parse(RestClient.get rest_url, @header)
  end
  
  ##
  #
  # This method will get the top offers in xml or json format
  # Usage:
  #  * fa.get_top_offers("json")  Can accept "xml".
  #
  # Output:
  # Details on topOffersList:
  #  * title - Title of the offer
  #  * description - Description about the offer
  #  * url - URL for the offer
  #  * imageUrls - List of Image URLs corresponding to the Offer
  #  * availability - Either “In-stock” / “Out-of-stock” about the products with offer.
  #
  def get_top_offers(format)
    rest_url = "#{@api}/offers/v1/top/#{format}"
    JSON.parse(RestClient.get rest_url, @header)
  end
 
  ##
  #
  # This method will get the full deatials of a particualar product.
  # Output will json or xml depending on format parameter (json, xml)
  # Usage:
  #  * fa.get_product_by_id("TVSDD2DSPYU3BFZY", "json")  
  #
  def get_product_by_id(product_id, format)
    rest_url = "#{@api}/product/#{format}?id=#{product_id}"
    RestClient.get rest_url, @header
  end

  ##
  #
  #This method will get all the products accross those matches the key sent as parameters.
  #Output will be json or xml depending on the parameter passed.
  #Usage:
  #  * fa.search("product name", "json", 5)
  #
  def search(key, format,  max_result=10)
    rest_url = "#{@api}/search/#{format}?query=#{key}&resultCount=#{max_result}"
    RestClient.get rest_url, @header
  end

  ##
  #
  # This method will get all the orders of perticular status. Output will be json or xml depending on parameter
  # Usage:
  #  * fa.orders_report("yyyy-MM-dd", "yyyy-MM-dd", "Pending", "json")
  #
  # status = Pending/Approved/Cancelled/Disapproved
  #
  def orders_report(start_date, end_date, status, format, offset=0)
    rest_url = "#{@api}/report/orders/detail/#{format}?startDate=#{start_date}&endDate=#{end_date}&status=#{status}&offset=#{offset}"
    RestClient.get rest_url, @header
  end
end
