module Hetzner
  class API
    module Reset
      # returns the reset status of a given IP address or all servers of the account
      def reset?(ip = nil)
        path = "/reset"
        path << "/#{ip}" if ip
        perform_get path
      end
      
      # resets a server by its IP address.
      #
      # <em>type</em> is one of:
      # * <b>sw</b>  (software reset)
      # * <b>hw</b>  (hardware reset)
      # * <b>man</b> (manual reset)
      def reset!(ip, type)
        perform_post "/reset/#{ip}", :query => { :type => type }
      end
    end
  end
end