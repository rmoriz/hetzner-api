module Hetzner
  class API
    module Boot
      module Linux
        def boot_linux?(ip)
          path = "/boot/#{ip}/linux"
          perform_get path
        end
      end
    end
  end
end
