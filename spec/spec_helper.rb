require 'coveralls'
Coveralls.wear!

require "spec_constants"
require "api_stubs"

RSpec.configure do |c|
  c.before(:suite) do
    FakeWeb.allow_net_connect = false
  end
  c.after(:suite) do
    FakeWeb.allow_net_connect = true
  end
end


RSpec::Matchers.define :have_JSON_error_code do |expected|
  match do |actual|
    actual['error']['code'] == expected.to_s
  end
end
