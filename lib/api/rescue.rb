module Hetzner
  class API
    module Rescue
      def enable_rescue!(ip, os = 'linux', arch = '64')
        perform_post "/boot/#{ip}/rescue", :query => { :os => os, :arch => arch }
      end
      
      def disable_rescue!(ip)
        perform_delete "/boot/#{ip}/rescue"
      end
    end
  end
end