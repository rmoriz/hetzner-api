require 'fakeweb'

@base_dir = File.dirname(__FILE__)

def fixture(path)
  file = File.expand_path(@base_dir + '/fixtures/' + @resource + '/' + path)
  file
end

def uri(path = nil)
  url = "https://#{API_USERNAME}:#{API_PASSWORD}@#{API_SERVER}/#{@resource}"
  url << "/#{path}" if path
  url
end


FakeWeb.allow_net_connect = false


@resource = 'reset'

FakeWeb.register_uri :get,   uri,
                     :response => fixture('get.raw')

FakeWeb.register_uri :get,   uri("#{WORKING_IP}"),
                     :response => fixture('get_with_ip.raw')

FakeWeb.register_uri :get,   uri("#{UNKOWN_IP}"),              
                     :response => fixture('get_with_ip_unknown.raw')

FakeWeb.register_uri :get,   uri("#{RESET_IP_NOT_AVAILABLE}"), 
                     :response => fixture('get_with_ip_unavailable.raw')

FakeWeb.register_uri :post,  uri("#{WORKING_IP}?type=sw"),             
                     :response => fixture('post_with_ip.raw')

FakeWeb.register_uri :post,  uri("#{WORKING_IP}?type=foo"),            
                     :response => fixture('post_with_ip_invalid_input.raw')

FakeWeb.register_uri :post,  uri("#{RESET_IP_MANUAL_ACTIVE}?type=sw"), 
                     :response => fixture('post_with_ip_manual_active.raw')

FakeWeb.register_uri :post,  uri("#{RESET_IP_NOT_AVAILABLE}?type=sw"), 
                     :response => fixture('post_with_ip_unavailable.raw')                     

FakeWeb.register_uri :post,  uri("#{UNKOWN_IP}?type=sw"), 
                     :response => fixture('post_with_ip_unknown.raw')                     


@resource = 'boot'

FakeWeb.register_uri :get,    uri("#{WORKING_IP}"),
                     :response => fixture('get_with_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}/rescue?arch=64&os=linux"),
                     :response => fixture('rescue/post.raw')

FakeWeb.register_uri :delete, uri("#{WORKING_IP}/rescue"),
                     :response => fixture('rescue/delete.raw')

FakeWeb.register_uri :get,    uri("#{WORKING_IP}/vnc"),
                     :response => fixture('vnc/get.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}/vnc?arch=32&lang=en_US&dist=Fedora-13"),
                     :response => fixture('vnc/post.raw')                     

FakeWeb.register_uri :delete, uri("#{WORKING_IP}/vnc"),
                     :response => fixture('vnc/delete.raw')  


@resource = 'wol'

FakeWeb.register_uri :get,    uri("#{WORKING_IP}"),
                     :response => fixture('get.raw')  

FakeWeb.register_uri :post,   uri("#{WORKING_IP}"),
                     :response => fixture('post.raw')  


@resource = 'rdns'

FakeWeb.register_uri :get,    uri("#{WORKING_IP}"),
                     :response => fixture('get_with_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}?ptr=testen.de"),
                     :response => fixture('post_with_ip.raw')

FakeWeb.register_uri :delete, uri("#{WORKING_IP}"),
                     :response => fixture('delete_with_ip.raw')

#pp FakeWeb::Registry.instance.uri_map