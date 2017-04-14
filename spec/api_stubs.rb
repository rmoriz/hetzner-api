require 'fakeweb'

@base_dir = File.dirname(__FILE__)

def fixture(path)
  file = File.expand_path(@base_dir + '/fixtures/' + @resource + '/' + path)
  file
end

def uri(path = nil, args = nil)
  url = "https://#{API_USERNAME}:#{API_PASSWORD}@#{API_SERVER}/#{@resource}"
  url << "/#{path}" if path
  url << args.to_s  if args
  url
end

@resource = 'reset'

FakeWeb.register_uri :get,   uri,
                     response: fixture('get.raw')

FakeWeb.register_uri :get,   uri(WORKING_IP.to_s),
                     response: fixture('get_with_ip.raw')

FakeWeb.register_uri :get,   uri(UNKOWN_IP.to_s),
                     response: fixture('get_with_ip_unknown.raw')

FakeWeb.register_uri :get,   uri(RESET_IP_NOT_AVAILABLE.to_s),
                     response: fixture('get_with_ip_unavailable.raw')

FakeWeb.register_uri :post,  uri("#{WORKING_IP}?type=sw"),
                     response: fixture('post_with_ip.raw')

FakeWeb.register_uri :post,  uri("#{WORKING_IP}?type=foo"),
                     response: fixture('post_with_ip_invalid_input.raw')

FakeWeb.register_uri :post,  uri("#{RESET_IP_MANUAL_ACTIVE}?type=sw"),
                     response: fixture('post_with_ip_manual_active.raw')

FakeWeb.register_uri :post,  uri("#{RESET_IP_NOT_AVAILABLE}?type=sw"),
                     response: fixture('post_with_ip_unavailable.raw')

FakeWeb.register_uri :post,  uri("#{UNKOWN_IP}?type=sw"),
                     response: fixture('post_with_ip_unknown.raw')

@resource = 'boot'

FakeWeb.register_uri :get,    uri(WORKING_IP.to_s),
                     response: fixture('get_with_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}/rescue?arch=64&os=linux"),
                     response: fixture('rescue/post.raw')

FakeWeb.register_uri :delete, uri("#{WORKING_IP}/rescue"),
                     response: fixture('rescue/delete.raw')

FakeWeb.register_uri :get,    uri("#{WORKING_IP}/vnc"),
                     response: fixture('vnc/get.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}/vnc?arch=32&lang=en_US&dist=Fedora-13"),
                     response: fixture('vnc/post.raw')

FakeWeb.register_uri :delete, uri("#{WORKING_IP}/vnc"),
                     response: fixture('vnc/delete.raw')

FakeWeb.register_uri :get,    uri("#{WORKING_IP}/plesk"),
                     response: fixture('plesk/get.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}/plesk?arch=32&lang=en_US&dist=Fedora-13&hostname=dr-gerner-aus-gzsz.confixx.de"),
                     response: fixture('plesk/post.raw') # perl2exe insider

FakeWeb.register_uri :delete, uri("#{WORKING_IP}/plesk"),
                     response: fixture('plesk/delete.raw')

FakeWeb.register_uri :get,    uri("#{WORKING_IP}/linux"),
                     response: fixture('linux/get.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}/linux?dist=CentOS%206.3%20minimal&lang=en&arch=64"),
                     response: fixture('linux/post.raw')

FakeWeb.register_uri :delete, uri("#{WORKING_IP}/linux"),
                     response: fixture('linux/delete.raw')

@resource = 'wol'

FakeWeb.register_uri :get,    uri(WORKING_IP.to_s),
                     response: fixture('get.raw')

FakeWeb.register_uri :post,   uri(WORKING_IP.to_s),
                     response: fixture('post.raw')

@resource = 'rdns'

FakeWeb.register_uri :get,    uri(WORKING_IP.to_s),
                     response: fixture('get_with_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}?ptr=testen.de"),
                     response: fixture('post_with_ip.raw')

FakeWeb.register_uri :delete, uri(WORKING_IP.to_s),
                     response: fixture('delete_with_ip.raw')

@resource = 'ip'

FakeWeb.register_uri :get,    uri,
                     response: fixture('get.raw')

FakeWeb.register_uri :get,    uri(nil, "?server_ip=#{WORKING_IP}"),
                     response: fixture('get_with_server_ip.raw')

FakeWeb.register_uri :get,    uri(WORKING_IP.to_s),
                     response: fixture('get_with_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}?traffic_warnings=true&traffic_monthly=2342"),
                     response: fixture('post_activate_with_data.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}?traffic_warnings=false"),
                     response: fixture('post_deactivate_with_data.raw')

@resource = 'subnet'

FakeWeb.register_uri :get,    uri,
                     response: fixture('get.raw')

FakeWeb.register_uri :get,    uri(nil, "?server_ip=#{WORKING_IP}"),
                     response: fixture('get_with_server_ip.raw')

FakeWeb.register_uri :get,    uri(WORKING_SUBNET_IP.to_s),
                     response: fixture('get_with_subnet_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_SUBNET_IP}?traffic_warnings=true&traffic_monthly=2342"),
                     response: fixture('post_activate_with_data.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_SUBNET_IP}?traffic_warnings=false"),
                     response: fixture('post_deactivate_with_data.raw')

@resource = 'server'

FakeWeb.register_uri :get,    uri,
                     response: fixture('get.raw')

FakeWeb.register_uri :get,    uri(WORKING_IP.to_s),
                     response: fixture('get_with_server_ip.raw')

FakeWeb.register_uri :post,   uri("#{WORKING_IP}?server_name=krautchan100"),
                     response: fixture('post_with_server_name.raw')

@resource = 'traffic'

FakeWeb.register_uri :post,   uri(nil, "?ip[]=#{WORKING_IP}&subnet[]=#{WORKING_SUBNET_IP}&from=2010-10-10T01&to=2010-10-10T10&type=day"),
                     response: fixture('post_with_one_ip_and_one_subnet_day.raw')

FakeWeb.register_uri :post,   uri(nil, "?ip[]=#{WORKING_IP}&ip[]=#{WORKING_IP_2}&subnet[]=&from=2010-09-01&to=2010-10-01&type=month"),
                     response: fixture('post_with_two_ips_and_no_subnet_month.raw')

FakeWeb.register_uri :post,   uri(nil, "?ip[]=&subnet[]=#{WORKING_SUBNET_IP}&subnet[]=#{WORKING_SUBNET_IP_2}&from=2010-01&to=2010-10&type=year"),
                     response: fixture('post_with_two_subnets_and_no_ip_year.raw')

@resource = 'failover'

FakeWeb.register_uri :get,    uri,
                     response: fixture('get.raw')

FakeWeb.register_uri :get,    uri(FAILOVER_IP.to_s),
                     response: fixture('get_with_failover_ip.raw')

FakeWeb.register_uri :post,    uri("#{FAILOVER_IP}?active_server_ip=#{WORKING_IP_2}"),
                     response: fixture('post_with_active_server_ip.raw')

# pp FakeWeb::Registry.instance.uri_map
