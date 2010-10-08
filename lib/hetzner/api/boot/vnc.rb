module Hetzner
  class API
    module Boot
      module VNC
        # queries the vnc boot status of one IP address/server
        def boot_vnc?(ip)
          path = "/boot/#{ip}/vnc"
          perform_get path
        end
      
        # enables vnc boot option for one IP address/server
        #
        # see <em>Boot</em> to query the API for available options
        def boot_vnc!(ip, dist, arch, lang)
          path = "/boot/#{ip}/vnc"
          perform_post path, :query => { :dist => dist, :arch => arch, :lang => lang }
        end
      
        # disables the vnc boot status of one IP address/server
        def disable_boot_vnc!(ip)
          path = "/boot/#{ip}/vnc"
          perform_delete path
        end
      end
    end
  end
end