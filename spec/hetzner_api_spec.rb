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
    result['rdns']['ip'].should == WORKING_IP
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
