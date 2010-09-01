module Hetzner
  class API
    module Boot
      def boot?(ip = nil)
        path = "/boot"
        path << "/#{ip}" if ip
        perform_get path
      end
    end
  end
end