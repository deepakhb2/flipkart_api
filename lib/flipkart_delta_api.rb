# coding: utf-8
require "flipkart_api"

class FlipkartDeltaApi < FlipkartApi

  ##
  #
  # This method will get the api for accessing all the products of a particular category.
  # Usage:
  #  * fa = FlipkartApi.new(fk_userid, fk_token)
  #  * fa.get_category_porducts_api("bags_wallets_belts")
  # Returns the api to get all the products of the category
  #
  def get_category_porducts_api(category)
    JSON.parse(get_categories("json"))["apiGroups"]["affiliate"]["apiListings"][category]["availableVariants"]["v0.1.0"]["deltaGet"]
  end

  ##
  #
  # This method will get the first 500 products from the given rest api in the json parsed data structure.
  # If version is passed only changed products since then is fetched.
  # Usage:
  #  * fa.get_products(rest_url, version)
  #
  def get_products(rest_url, version=nil)
    if !rest_url.include?('fromVersion')
        if (version.nil?)
            rest_url.gsub!('.json','/fromVersion/0.json')
        else
            rest_url.gsub!('.json',"/fromVersion/#{version}.json")
        end
    end
    rest_output = RestClient.get rest_url, @header
    json_data = JSON.parse(rest_output)
  end

  ##
  #
  # This method will get the current version of data from the delta apis
  # Usage:
  #  * fa.get_current_version(rest_url)
  #
  def get_current_version(rest_url)
    rest_output = RestClient.get rest_url, @header
    json_data = JSON.parse(rest_output)
  end
end
