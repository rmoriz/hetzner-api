module Hetzner
  class API
    module Boot
      module Plesk
        # queries the plesk boot status of one IP address/server
        def boot_plesk?(ip)
          path = "/boot/#{ip}/plesk"
          perform_get path
        end
        
        # enables plesk boot option for one IP address/server
        #
        # see <em>Boot</em> to query the API for available options
        def boot_plesk!(ip, dist, arch, lang, hostname)
          path = "/boot/#{ip}/plesk"
          perform_post path, :query => { :dist => dist, :arch => arch, :lang => lang, :hostname => hostname }
        end
      
        # disables the vnc boot status of one IP address/server
        def disable_boot_plesk!(ip)
          path = "/boot/#{ip}/plesk"
          perform_delete path
        end
        
      end
    end
  end
end