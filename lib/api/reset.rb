module Hetzner
  class API
    module Reset
      def reset?(ip = nil)
        path = "/reset"
        path << "/#{ip}" if ip
        perform_get path
      end
      
      def reset!(ip, type)
        perform_post "/reset/#{ip}", :query => { :type => type }
      end
    end
  end
end