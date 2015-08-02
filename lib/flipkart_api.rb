require "rest-client"

class FlipkartApi

  ##
  #
  # Initialize object with userid and token to send api calls.
  #
  def initialize(fk_userid, fk_token)
    @api = "https://affiliate-api.flipkart.net/affiliate"
    @header = {"Fk-Affiliate-Id" => fk_userid, "Fk-Affiliate-Token" => fk_token}
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
    rest_url="#{@api}/api/#{@header['Fk-Affiliate-Token']}.#{format}"
    RestClient.get rest_url
  end

  ##
  #
  # This method will get the api for accessing all the products of a particular category.
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_category_porducts_api("bags_wallets_belts")
  # Returns the api to get all the products of the category
  #
  def get_category_porducts_api(category)
    JSON.parse(get_categories("json"))["apiGroups"]["affiliate"]["apiListings"][category]["availableVariants"]["v0.1.0"]["get"]
  end

  ##
  #
  # This method will get the first 500 products in the json parsed data structure.
  # Output will also contain "nextUrl" which inturn returns next 500 products.
  # Usage:
  #  * fa.get_products_by_category("bags_wallets_belts")
  #
  def get_products_by_category(category)
    get_products(get_category_product_api(category))
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
    RestClient.get rest_url, @header
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
    RestClient.get rest_url, @header
  end
 
  ##
  #
  # This method will get the full deatials of a particualar product.
  # Output will json or xml depending on format parameter (json, xml)
  # Usage:
  #  * fa.getproduct_by_id("TVSDD2DSPYU3BFZY", "json")  
  #
  def get_product_by_id(product_id, format)
    rest_url = "#{@api}/product/#{format}?id=#{product_id}"
    RestClient.get rest_url, @header
  end
end
