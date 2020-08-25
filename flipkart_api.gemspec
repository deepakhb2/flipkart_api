Gem::Specification.new do |s|  
  s.name        = 'flipkart_api'
  s.version     = '0.1.0'
  s.date        = '2017-01-29'
  s.summary     = "This gem will help you to pull data from flipkart using flipkart api"
  s.description = "Pull data from flipkart by using api"
  s.authors     = ["Deepak HB", "Girish Nair"]
  s.email       = 'deepakhb2@gmail.com'
  s.files       = ["lib/flipkart_api.rb"]
  s.homepage    =
    'https://github.com/deepakhb2/flipkart_api'

  s.add_dependency('rest-client', '2.1.0')

  s.required_ruby_version = '>= 1.9.3'

  s.license       = 'MIT'
end
