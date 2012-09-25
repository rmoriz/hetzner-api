require 'httparty'
#require 'forwardable'

require 'hetzner/api/cli'

require 'hetzner/api/failover'
require 'hetzner/api/rdns'
require 'hetzner/api/reset'
require 'hetzner/api/wol'
require 'hetzner/api/server'
require 'hetzner/api/ip'
require 'hetzner/api/subnet'
require 'hetzner/api/traffic'
require 'hetzner/api/boot/linux'
require 'hetzner/api/boot/rescue'
require 'hetzner/api/boot/vnc'
require 'hetzner/api/boot/windows'
require 'hetzner/api/boot/plesk'
require 'hetzner/api/boot'

module Hetzner
  class API
    include ::HTTParty
    format :json
    base_uri 'https://robot-ws.your-server.de'
        
    include Boot
    include Failover
    include Rdns
    include Reset
    include WOL
    include Server
    include IP
    include Subnet
    include Traffic
    
    def initialize(username, password)
      @auth = {:username => username, :password => password}
    end
    
  private
    
    def perform_get(path, options = {})
      options.merge!({:basic_auth => @auth})
      Hetzner::API.get path, options
    end
    
    def perform_post(path, options = {})
      options.merge!({:basic_auth => @auth})
      options[:headers] = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      Hetzner::API.post path, options
    end
    
    def perform_delete(path, options = {})
      options.merge!({:basic_auth => @auth})
      Hetzner::API.delete path, options
    end
    
    def perform_put(path, options = {})
      options.merge!({:basic_auth => @auth})
      Hetzner::API.put path, options
    end
  end
end