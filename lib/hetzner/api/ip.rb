module Hetzner
  class API
    module IP
      # shows all addresses that belong to the main server IP
      def ips_for_server?(server_ip)
        path = "/ip"
        perform_get path, :query => { :server_ip => server_ip }
      end
      
      # shows information of all IP addresses of the customer 
      def ips?
        get_ip_or_ips
      end   
      
      # shows information of a given IP addresses of the customer
      def ip?(ip)
        get_ip_or_ips ip
      end
      
      # sets or unsets traffic warning limits on a specific IP address
      def ip!(ip, options = {})
        path = "/ip/#{ip}"
        perform_post path, :query => options
      end
      
      private
      
      def get_ip_or_ips(ip = nil)
        path = "/ip"
        path << "/#{ip}" if ip
        perform_get path
      end
    end
  end
end