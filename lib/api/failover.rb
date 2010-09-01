module Hetzner
  class API
    module Failover
      def failover?(ip = nil)
        path = "/failover"
        path << "/#{ip}" if @ip
        perform_get path
      end
      
      def failover!(failover_ip, active_server_ip)
        path = "/rdns/#{failover_ip}"
        perform_post path, :query => { :active_server_ip => active_server_ip }
      end
    end
  end
end