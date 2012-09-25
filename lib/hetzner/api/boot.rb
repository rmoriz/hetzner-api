module Hetzner
  class API
    module Boot
      include Linux
      include Plesk
      include Rescue
      include VNC
      include Windows
      
      # lists boot options for a given IP address/server or all servers of the account
      def boot?(ip = nil)
        path = "/boot"
        path << "/#{ip}" if ip
        perform_get path
      end
    end
  end
end