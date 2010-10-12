module Hetzner
  class API
    module Failover
      # queries the failover status of one IP address or all failover IP addresses of the account
      def failover?(ip = nil)
        path = "/failover"
        path << "/#{ip}" if ip
        perform_get path
      end
      
      # redirects the failover_ip to another server ip
      def failover!(failover_ip, active_server_ip)
        path = "/failover/#{failover_ip}"
        perform_post path, :query => { :active_server_ip => active_server_ip }
      end
    end
  end
end