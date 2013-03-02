require 'coveralls'
Coveralls.wear!

require 'fakeweb'
require File.expand_path('../../../spec/spec_constants.rb', __FILE__)
require File.expand_path('../../../spec/api_stubs.rb', __FILE__)

ENV['HETZNER_API_CUCUMBER_TEST'] = "1"

# This long timeout is needed for jruby, as each step launches a jruby instance for the cli
#
Before do
  @aruba_timeout_seconds = 60
  FakeWeb.allow_net_connect = false
end

