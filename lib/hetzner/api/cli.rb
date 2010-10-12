require 'thor'
require 'ipaddr'
require 'pp'
require 'json'
require 'xmlsimple'

module Hetzner
  class API
    class CLI < Thor
      attr_accessor :api
      
      desc "boot ACTION [SERVER_IP]", "get available boot options"
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
        end
        
        output(result)
      end
      
      desc "failover [SERVER_IP] (--to [FAILOVER_IP])", "get/set failover of SERVER_IP (to FAILOVER_IP)"
      method_options :username => :string
      method_options :password => :string
      method_options :to       => :string
      
      def failover(ip = nil)
        generate_api_instance

        if options.to
          require_ip ip
          require_ip options.to
          result = @api.failover! ip, options.to
        else
          result = @api.failover? ip
        end
       
        output(result)
      end
      
      private
      
      def output(result)
        @render = 'xml'
        case @render
        when 'pp'
          pp result.parsed_response
        when 'yaml'
          puts result.parsed_response.to_yaml
        when 'xml'
          puts XmlSimple.xml_out result.parsed_response, 'RootName' => 'result', 'AnonymousTag' => '' # dirty
        when 'json'
        else
          jj JSON.parse result.response.body
        end
      end
      
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
