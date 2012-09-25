module Hetzner
  class API
    module Boot
      module Linux
        def boot_linux?(ip)
          path = "/boot/#{ip}/linux"
          perform_get path
        end

        def boot_linux!(ip, dist, arch, lang)
          path = "/boot/#{ip}/linux"
          perform_post path, :query => {:dist => dist, :arch => arch, :lang => lang }
        end

        def disable_boot_linux!(ip)
          path = "/boot/#{ip}/linux"
          perform_delete path
        end
      end
    end
  end
end
