module Hetzner
  class API
    module Subnet
      # shows all IP subnets that belong to the main server IP
      def subnets_for_server?(server_ip)
        path = "/subnet"
        perform_get path, :query => { :server_ip => server_ip }
      end
      
      # shows information of all IP subnets of the customer 
      def subnets?
        get_subnets_or_subnet
      end   
      
      # shows information of a given IP subnets of the customer
      def subnet?(ip)
        get_subnets_or_subnet ip
      end
      
      # sets or unsets traffic warning limits on a specific IP subnet address
      def subnet!(ip, options = {})
        path = "/subnet/#{ip}"
        perform_post path, :query => options
      end
      
      private
      
      def get_subnets_or_subnet(ip = nil)
        path = "/subnet"
        path << "/#{ip}" if ip
        perform_get path
      end
    end
  end
end