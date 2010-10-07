require "spec_constants"
require "api_stubs"

RSpec::Matchers.define :have_JSON_error_code do |expected|
  match do |actual|
    actual['error']['code'] == expected.to_s
  end
end