ENV['HETZNER_API_CUCUMBER_TEST'] = "1"

# This long timeout is needed for jruby, as each step launches a jruby instance for the cli
#
Before do
  @aruba_timeout_seconds = 60
end
