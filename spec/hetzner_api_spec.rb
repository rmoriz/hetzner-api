require 'hetzner-api'
require 'spec_helper'

describe "Reset" do
  describe "query" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end

    it "should list available reset options for all servers" do
      result = @h.reset?
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have_at_least(1).entry
    end

    it "should list available reset options for a specific IP" do
      result = @h.reset? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have_key('reset')
    end

    it "should fail when IP is unknown" do
      result = @h.reset? UNKOWN_IP
      result.response.should be_an_instance_of Net::HTTPNotFound 
      result.parsed_response.should have_JSON_error_code :SERVER_NOT_FOUND
    end

    it "should fail when IP has no reset option" do
      result = @h.reset? RESET_IP_NOT_AVAILABLE
      result.response.should be_an_instance_of Net::HTTPNotFound 
      result.parsed_response.should have_JSON_error_code :RESET_NOT_AVAILABLE
    end
  end

  describe "execution" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end

    it "should reset the specific IP" do
      result = @h.reset! WORKING_IP, :sw
      result.response.should be_an_instance_of Net::HTTPOK
    end

    it "should fail for the specific IP if input is invalid" do
      result = @h.reset! WORKING_IP, :foo
      result.response.should be_an_instance_of Net::HTTPBadRequest
      result.parsed_response.should have_JSON_error_code :INVALID_INPUT 
    end

    it "should fail for the specific IP if a manual reset is active" do
      result = @h.reset! RESET_IP_MANUAL_ACTIVE, :sw
      result.response.should be_an_instance_of Net::HTTPConflict
      result.parsed_response.should have_JSON_error_code :RESET_MANUAL_ACTIVE
    end

    it "should fail for the specific IP if reset is unavailable" do
      result = @h.reset! RESET_IP_NOT_AVAILABLE, :sw
      result.response.should be_an_instance_of Net::HTTPNotFound
      result.parsed_response.should have_JSON_error_code :RESET_NOT_AVAILABLE
    end

    it "should fail for the specific IP if IP is unknown" do
      result = @h.reset! UNKOWN_IP, :sw
      result.response.should be_an_instance_of Net::HTTPNotFound
      result.parsed_response.should have_JSON_error_code :SERVER_NOT_FOUND
    end
  end
end

describe "Boot" do
  describe "query boot configuration" do 
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end

    it "should display the boot configuration" do
      result = @h.boot? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
    end
  end

  describe "a linux system" do
    before(:all) do
      @hetzner_api = Hetzner::API.new API_USERNAME, API_PASSWORD
    end

    it "should be able to query the boot options" do
      result = @hetzner_api.boot_linux? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
    end

    it "should be able to activate the installation" do
      result = @hetzner_api.boot_linux! WORKING_IP, "CentOS 6.3 minimal", "64", "en"
      result.response.should be_an_instance_of Net::HTTPOK
    end

    pending "should be able to deactivate the installation" do

    end
  end

  describe "the rescue system" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end

    it "should be able to activate" do
      result = @h.enable_rescue! WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK

      # {"rescue"=>{"arch"=>64, "os"=>"linux", "server_ip"=>WORKING_IP, "password"=>"h9JbXPz8", "active"=>true}} 
      #result['rescue']['arch'].should == 64
      #result['rescue']['os'].should == 'linux'
      #result['rescue']['active'].should be_true
    end

    it "should be able to deactivate" do
      result = @h.disable_rescue! WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
    end
  end
end

describe "Rdns" do
  before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end

  it "should query the current rdns status" do
    result = @h.rdns? WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['rdns']['ip'].should  == WORKING_IP
    result['rdns']['ptr'].should == TEST_PTR
  end

  it "should be able to set a new ptr" do
    result = @h.rdns! WORKING_IP, TEST_PTR
    result.response.should be_an_instance_of Net::HTTPOK
    result['rdns']['ip'].should  == WORKING_IP
    result['rdns']['ptr'].should == TEST_PTR
  end
  
  it "should be able to remove a new ptr" do
    result = @h.delete_rdns! WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
  end
end

describe "VNC" do
  before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end

  it "should be able to query vnc boot status" do
    result = @h.boot_vnc? WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['vnc']['server_ip'].should == WORKING_IP
    result['vnc']['active'].should be_false
    result['vnc']['password'].should be_nil
  end

  it "should be able to set vnc boot status" do
    result = @h.boot_vnc! WORKING_IP, 'Fedora-13', '32', 'en_US'
    result.response.should be_an_instance_of Net::HTTPOK
    result['vnc']['server_ip'].should == WORKING_IP
    result['vnc']['active'].should be_true
    result['vnc']['password'].should_not be_nil
  end

  it "should be able to disable vnc boot status" do
    result = @h.disable_boot_vnc! WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['vnc']['server_ip'].should == WORKING_IP
    result['vnc']['active'].should be_false
    result['vnc']['password'].should be_nil
  end
end

describe "WOL" do
  before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end

  it "should be able to query WOL status" do
    result = @h.wol? WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['wol']['server_ip'].should == WORKING_IP
  end

  it "should be able to send a WOL notification" do
    result = @h.wol! WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['wol']['server_ip'].should == WORKING_IP
  end
end

describe 'IP' do
  describe "information" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end
    
    it "should be able to display all IP addresses of the customer account" do
      result = @h.ips?
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have_at_least(2).entries
    end

    it "should be able to display a IP address of the customer account" do
      result = @h.ip? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end
    
    it "should be able to display all IP addresses for a given server IP address" do
      result = @h.ips_for_server? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(2).entry
    end
  end

  describe "manage traffic warnings" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end
    
    it "should be able to activate and set traffic warning limits on a specific IP address" do
      result = @h.ip! WORKING_IP, :traffic_warnings => 'true', :traffic_monthly => TRAFFIC_LIMIT_IN_GIGABYTE
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end
    
    it "should be able to deactivate traffic warnings for a specific IP address" do
      result = @h.ip! WORKING_IP, :traffic_warnings => 'false'
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end
  end
end

describe 'Subnet' do
  describe "information" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end
    
    it "should be able to display all IP subnets of the customer account" do
      result = @h.subnets?
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have_at_least(2).entries
    end

    it "should be able to display a IP subnet of the customer account" do
      result = @h.subnet? WORKING_SUBNET_IP
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end

    it "should be able to display all IP addresses for a given server IP address" do
      result = @h.subnets_for_server? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end
  end

  describe "manage traffic warnings" do
    before(:all) do
      @h = Hetzner::API.new API_USERNAME, API_PASSWORD
    end

    it "should be able to activate and set traffic warning limits on a specific IP address" do
      result = @h.ip! WORKING_IP, :traffic_warnings => 'true', :traffic_monthly => TRAFFIC_LIMIT_IN_GIGABYTE
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end

    it "should be able to deactivate traffic warnings for a specific IP address" do
      result = @h.ip! WORKING_IP, :traffic_warnings => 'false'
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have(1).entry
    end
  end
end

describe "Server" do
  before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end

  describe "information" do
    it "should be able to display all servers of the customer account" do
      result = @h.servers?
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have_at_least(2).entries
    end

    it "should be able to display a specific server by its IP address" do
      result = @h.server? WORKING_IP
      result.response.should be_an_instance_of Net::HTTPOK
      result.parsed_response.should have_at_least(1).entry
    end
  end

  it "should be able to set a server_name" do
    result = @h.server! WORKING_IP, :server_name => 'krautchan100'
    result.response.should be_an_instance_of Net::HTTPOK
    result.parsed_response.should have_at_least(1).entry
    result.parsed_response['server_name'] == 'krautchan100'
  end
end

describe "Plesk" do
  before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end

  it "should be able to query plesk boot option status" do
    result = @h.boot_plesk? WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['plesk']['server_ip'].should == WORKING_IP
    result['plesk']['active'].should be_false
    result['plesk']['password'].should be_nil
  end

  it "should be able to activate plesk boot option" do
    result = @h.boot_plesk! WORKING_IP, 'Fedora-13', '32', 'en_US', 'dr-gerner-aus-gzsz.confixx.de'
    result.response.should be_an_instance_of Net::HTTPOK
    result['plesk']['server_ip'].should == WORKING_IP
    result['plesk']['active'].should be_true
    result['plesk']['password'].should_not be_nil
  end

  it "should be able to disable plesk boot option" do
    result = @h.disable_boot_plesk! WORKING_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['plesk']['server_ip'].should == WORKING_IP
    result['plesk']['active'].should be_false
    result['plesk']['password'].should be_nil
  end
end

describe "Failover" do
  before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end
  
  it "should be able to query the status of all failover IPs" do
    result = @h.failover?
    result.response.should be_an_instance_of Net::HTTPOK
    result.parsed_response.should have(2).entries
    
    # default in mode
    result[0]['failover']['ip'].should               == FAILOVER_IP
    result[0]['failover']['active_server_ip'].should == FAILOVER_IP
    
    # currently re-routed
    result[1]['failover']['ip'].should == FAILOVER_IP_2
    result[1]['failover']['active_server_ip'].should == FAILOVER_IP
  end
  
  it "should be able to query the status of a single failover IP" do
    result = @h.failover? FAILOVER_IP
    result.response.should be_an_instance_of Net::HTTPOK
    result['failover']['ip'].should               == FAILOVER_IP
    result['failover']['netmask'].should          == '255.255.255.255' 
    result['failover']['server_ip'].should        == FAILOVER_IP
    result['failover']['active_server_ip'].should == WORKING_IP
  end
  
  it "should be able to set the status of a single failover IP" do
    result = @h.failover! FAILOVER_IP, WORKING_IP_2
    result.response.should be_an_instance_of Net::HTTPOK
    result['failover']['ip'].should               == FAILOVER_IP
    result['failover']['netmask'].should          == '255.255.255.255' 
    result['failover']['server_ip'].should        == FAILOVER_IP
    result['failover']['active_server_ip'].should == WORKING_IP_2
  end
end


describe "Traffic" do
   before(:all) do
    @h = Hetzner::API.new API_USERNAME, API_PASSWORD
  end

  it "should display the traffic for a specific ip address and a subnet" do
    options = {
      :ips     => [WORKING_IP],
      :subnets => [WORKING_SUBNET_IP],
      :from    => DateTime.parse('10.10.2010 01:00'),
      :to      => DateTime.parse('10.10.2010 10:21'),
      :type    => :day
    }

    result = @h.traffic? options

    result.response.should be_an_instance_of Net::HTTPOK
  end

  it "should display the traffic for serveral IP addresse and no subnet" do
    options = {
      :ips     => [WORKING_IP, WORKING_IP_2],
      :subnets => [],
      :from    => "01.09.2010",
      :to      => "01.10.2010",
      :type    => :month
    }

    result = @h.traffic? options

    result.response.should be_an_instance_of Net::HTTPOK
  end

  it "should display the traffic for subnets and no ip address" do
    options = {
      :ips     => [],
      :subnets => [WORKING_SUBNET_IP, WORKING_SUBNET_IP_2],
      :from    => "01.01.2010",
      :to      => "01.10.2010",
      :type    => :year
    }

    result = @h.traffic? options

    result.response.should be_an_instance_of Net::HTTPOK
  end
end
