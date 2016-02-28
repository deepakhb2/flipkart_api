Gem::Specification.new do |s|  
  s.name        = 'flipkart_api'
  s.version     = '0.0.2'
  s.date        = '2015-08-04'
  s.summary     = "This gem is to pull data from flipkart using flipkart api"
  s.description = "Pull data from flipkart by using api"
  s.authors     = ["Deepak HB", "Girish Nair"]
  s.email       = 'deepakhb2@gmail.com'
  s.files       = ["lib/flipkart_api.rb"]
  s.homepage    =
    'https://github.com/deepakhb2/flipkart_api'

  s.add_dependency('rest-client', '1.7.2')

  s.required_ruby_version = '>= 1.9.3'

  s.license       = 'MIT'
end
