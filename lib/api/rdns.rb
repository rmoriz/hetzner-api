module Hetzner
  class API
    module Rdns
      def rdns?(ip)
        path = "/rdns/#{ip}"
        perform_get path
      end
      
      def rdns!(ip, ptr)
        path = "/rdns/#{ip}"
        perform_post path, :query => { :ptr => ptr }
      end
      
      def initialize_rdns!(ip, ptr)
        path = "/rdns/#{ip}"
        perform_put path, :query => { :ptr => ptr }
      end
      
      def delete_rdns!(ip)
        path = "/rdns/#{ip}"
        perform_delete path
      end
    end
  end
end