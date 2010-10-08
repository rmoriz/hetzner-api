module Hetzner
  class API
    module Server
      # returns a list of all servers or just for a specific server ip
      def server?(server_ip = nil)
        path = "/server"
        path << "/#{server_ip}" if server_ip
        perform_get path
      end
    end
  end
end