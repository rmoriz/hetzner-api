module Hetzner
  class API
    module WOL
      def wol?(ip)
        path = "/wol/#{ip}"
        perform_get path
      end
      def wol!(ip)
        path = "/wol/#{ip}"
        perform_post path
      end
    end
  end
end