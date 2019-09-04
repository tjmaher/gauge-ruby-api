require 'net/http'
require 'test/unit'
require 'json'
include Test::Unit::Assertions

step 'Passing <route> to ROUTES api returns <long_name>', continue_on_failure: true do |route, long_name|
  uri = URI("https://api-v3.mbta.com/routes/#{route}")
  puts "Connecting to: #{uri}"

  request = Net::HTTP::Get.new(uri)

  req_options = {
    use_ssl: uri.scheme == "https"
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  assert_equal("200", response.code)

  attributes = JSON.parse(response.body)['data']['attributes']
  assert_equal(long_name, attributes['long_name'])
end
