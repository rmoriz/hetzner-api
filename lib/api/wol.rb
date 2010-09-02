module Hetzner
  class API
    module WOL
      # queries the WOL of one IP address/server
      def wol?(ip)
        path = "/wol/#{ip}"
        perform_get path
      end
      
      # triggers a WOL packet for given IP address/server
      def wol!(ip)
        path = "/wol/#{ip}"
        perform_post path
      end
    end
  end
end