require "rest-client"

class FlipkartApi
  def initialize(fk_userid, fk_token)
    @api = "https://affiliate-api.flipkart.net/affiliate"
    @header = {"Fk-Affiliate-Id" => fk_userid, "Fk-Affiliate-Token" => fk_token}
  end
  
  def get_categories
    format="json"
    rest_url="#{@api}/api/#{@header['Fk-Affiliate-Token']}.#{format}"
    RestClient.get rest_url
  end
  
  def get_products_by_category(category)
    rest_url = JSON.parse(get_categories)["apiGroups"]["affiliate"]["apiListings"][category]["availableVariants"]["v0.1.0"]["get"]
    get_all_products(rest_url)
  end
  
  def get_all_products(rest_url)
    rest_output = RestClient.get rest_url, @header
    all_products = [rest_output]
    json_data = JSON.parse(rest_output)
    while json_data["nextUrl"]
      rest_output = RestClient.get json_data["nextUrl"], @header
      all_products<<[rest_output]
      json_data = JSON.parse(rest_output)
    end
  end
  
  def get_dotd_offers(format)
    rest_url = "#{@api}/offers/v1/dotd/#{format}"
    RestClient.get rest_url, @header
  end
  
  def get_top_offers(format)
    rest_url = "#{@api}/offers/v1/top/#{format}"
    RestClient.get rest_url, @header
  end
  
  def get_product_by_id(product_id)
    rest_url = "#{@api}/product/json?id=#{product_id}"
    RestClient.get rest_url, @header
  end
end
