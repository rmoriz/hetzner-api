module Hetzner
  class API
    module Rescue
      # enables the rescue systm for given IP address/server using <em>os</em> (operating system) and <em>arch</em> (architecture)
      #
      # see <em>boot?</em> method to query the API for available options
      #
      # defaults to 64bit Linux
      def enable_rescue!(ip, os = 'linux', arch = '64')
        perform_post "/boot/#{ip}/rescue", :query => { :os => os, :arch => arch }
      end
      
      # disables the rescue system for a given IP address/server
      def disable_rescue!(ip)
        perform_delete "/boot/#{ip}/rescue"
      end
    end
  end
end