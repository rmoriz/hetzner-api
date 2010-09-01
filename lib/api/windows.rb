module Hetzner
  class API
    module Windows
      def boot_windows?(ip)
        path = "/boot/#{ip}/windows"
        perform_get path
      end

      def boot_windows!(ip, lan)
        path = "/boot/#{ip}/windows"
        perform_post path, :query => { :lang => lang }
      end

      def disable_boot_windows!(ip)
        path = "/boot/#{ip}/windows"
        perform_delete path
      end
    end
  end
end