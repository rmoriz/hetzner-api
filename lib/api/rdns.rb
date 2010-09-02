module Hetzner
  class API
    module Rdns
      # queries the reverse mapping status of one IP address
      def rdns?(ip)
        path = "/rdns/#{ip}"
        perform_get path
      end
      
      # creates or updates a reverse mapping record.
      # ptr contains a hostname
      def rdns!(ip, ptr)
        path = "/rdns/#{ip}"
        perform_post path, :query => { :ptr => ptr }
      end
      
      # creates a reverse mapping record. fails if already one exists
      # ptr contains a hostname
      def initialize_rdns!(ip, ptr)
        path = "/rdns/#{ip}"
        perform_put path, :query => { :ptr => ptr }
      end
      
      # delete the reverse mapping of one IP address
      def delete_rdns!(ip)
        path = "/rdns/#{ip}"
        perform_delete path
      end
    end
  end
end