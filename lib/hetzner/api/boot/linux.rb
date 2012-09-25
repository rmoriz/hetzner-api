module Hetzner
  class API
    module Boot
      module Linux
        def boot_linux?(ip)
          perform_get boot_linux_path(ip)
        end

        def boot_linux!(ip, dist, arch, lang)
          perform_post boot_linux_path(ip), :query => {:dist => dist, :arch => arch, :lang => lang }
        end

        def disable_boot_linux!(ip)
          perform_delete boot_linux_path(ip)
        end

      private
        def boot_linux_path(ip)
          "/boot/#{ip}/linux"
        end
      end
    end
  end
end
