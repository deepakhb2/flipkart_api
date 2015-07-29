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
    json_arr = []
    json_data = get_products rest_url
    json_arr << [json_data]
    while json_data["nextUrl"]
      puts json_data["nextUrl"]
      json_data = get_products json_data["nextUrl"]
      json_arr << [json_data]
    end
    jsonout = json_arr.to_json
  end

  def get_products(rest_url)
    rest_output = RestClient.get rest_url, @header
    json_data = JSON.parse(rest_output)
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
