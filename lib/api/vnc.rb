module Hetzner
  class API
    module VNC
      def boot_vnc?(ip)
        path = "/boot/#{ip}/vnc"
        perform_get path
      end

      def boot_vnc!(ip, dist, arch, lang)
        path = "/boot/#{ip}/vnc"
        perform_post path, :query => { :dist => dist, :arch => arch, :lang => lang }
      end

      def disable_boot_vnc!(ip)
        path = "/boot/#{ip}/vnc"
        perform_delete path
      end
    end
  end
end