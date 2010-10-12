require 'thor'
require 'ipaddr'
require 'pp'
require 'json'

module Hetzner
  class API
    class CLI < Thor
      attr_accessor :api
      
      desc "boot ACTION [SERVER_IP]", "'get' available boot options"
      method_options :username => :string
      method_options :password => :string
      method_options :set      => 'get'
      
      def boot(ip = "")
        require_ip ip
        generate_api_instance
        
        case options.set
          when 'get'
            require_ip ip
            result = @api.boot? ip
            pp result.parsed_response
        end
      end
      
      
      desc "failover [SERVER_IP]", "get available boot options"
      method_options :username => :string
      method_options :password => :string
      method_options :set      => 'get'

      def failover(ip)
        require_ip ip
        generate_api_instance
        
        case options.set
          when 'set'
            result = @api.failover! ip
            pp result.parsed_response
          #  raise UnknownArgumentError, "'#{action}' is not a valid action!"
          when 'get'
            result = @api.failover? ip
            pp result.parsed_response
        end
      end
      
      private
      
      def require_ip(ip)
        ip = IPAddr.new ip
      rescue ArgumentError
        raise RequiredArgumentMissingError, "server IP missing!"
      end
      
      def generate_api_instance
        if options.username && options.password
          @api = Hetzner::API.new options.username, options.password
        else
          # TODO: load from .hetzner
          raise RequiredArgumentMissingError, "missing credentials!"
        end
      end
    end
  end
end
