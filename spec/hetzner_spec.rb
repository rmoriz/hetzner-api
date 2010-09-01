require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

TEST_IP      = ''
TEST_PTR     = ''
RDNS_TEST_IP = ''
USERNAME     = ''
PASSWORD     = ''
                
describe "Reset" do
  describe "query status" do
    before(:all) do
      @h = Hetzner::API.new(USERNAME, PASSWORD)
    end

    it "should list available reset options" do
      result = @h.reset?
      result.should == [{"reset"=>{"server_ip"=>TEST_IP, "type"=>["man", "hw", "sw"]}}]
    end

    it "should list available reset options" do
      result = @h.reset? TEST_IP
      result.should == {"reset"=>{"server_ip"=>TEST_IP, "type"=>["man", "hw", "sw"]}}
    end

    it "should fail on a unknown ip" do
      result = @h.reset? "127.0.0.1" 
      result['error']['status'].should == 404
    end
  end

  describe "do reset" do
    before(:all) do
      @h = Hetzner::API.new(USERNAME, PASSWORD)
    end
    
    it "should reset the server" do
      result = @h.reset! "123.123.123.223", :sw
      result.should == { "reset"=> {"server_ip"=>"123.123.123.123", "type"=> "sw" } }
    end
  end
end

describe "Boot" do
  describe "query boot configuration" do 
    before(:all) do
      @h = Hetzner::API.new(USERNAME, PASSWORD)
    end
    
    it "should display the boot configuration" do
      result = @h.boot? TEST_IP 
      result.should == {"boot"=>{"vnc"=>{"arch"=>[64, 32], "server_ip"=>TEST_IP, "lang"=>["de_DE", "en_US", "fr_FR"], "dist"=>["centOS-5.3", "centOS-5.4", "centOS-5.5", "Fedora-11", "Fedora-12", "Fedora-13", "Fedora-9", "openSUSE-11.0", "openSUSE-11.1", "openSUSE-11.3"], "password"=>nil, "active"=>false}, "rescue"=>{"arch"=>[64, 32], "os"=>["linux", "freebsd", "opensolaris", "vkvm"], "server_ip"=>TEST_IP, "password"=>nil, "active"=>false}, "windows"=>{"server_ip"=>TEST_IP, "lang"=>nil, "dist"=>nil, "password"=>nil, "active"=>false}}}
    end
  end
  
  describe "Rescue" do
    before(:all) do
      @h = Hetzner::API.new(USERNAME, PASSWORD)
    end
    it "should be able to activate" do
      result = @h.enable_rescue! TEST_IP
      
      # {"rescue"=>{"arch"=>64, "os"=>"linux", "server_ip"=>TEST_IP, "password"=>"h9JbXPz8", "active"=>true}} 
      result['rescue']['arch'].should == 64
      result['rescue']['os'].should == 'linux'
      result['rescue']['active'].should be_true
    end
    
    it "should be able to deactivate" do
      result = @h.disable_rescue! TEST_IP
      result.should == {"rescue"=>{"arch"=>[64, 32], "os"=>["linux", "freebsd", "opensolaris", "vkvm"], "server_ip"=>TEST_IP, "password"=>nil, "active"=>false}}
    end
  end
end

describe "Rdns" do
  before(:all) do
    @h = Hetzner::API.new(USERNAME, PASSWORD)
  end
  
  it "should query the current rdns status" do
    result = @h.rdns? TEST_IP
    result['rdns']['ip'].should == TEST_IP
    result['rdns']['ptr'].should == TEST_PTR
  end
  
  it "should be able to set a new ptr" do
    result = @h.rdns! RDNS_TEST_IP, 'testen.de'
    result['rdns']['ip'].should == RDNS_TEST_IP
    result['rdns']['ptr'].should == 'testen.de'
  end
  
  it "should be able to remove a new ptr" do
    result = @h.delete_rdns! RDNS_TEST_IP
    puts result
  end
end

describe "VNC" do
  before(:all) do
    @h = Hetzner::API.new(USERNAME, PASSWORD)
  end
  
  it "should be able to query vnc boot status" do
    result = @h.boot_vnc? TEST_IP
    result['vnc']['server_ip'].should == TEST_IP
    result['vnc']['active'].should be_false
    result['vnc']['password'].should be_nil
  end
  
  it "should be able to set vnc boot status" do
    result = @h.boot_vnc! TEST_IP, 'Fedora-13', '32', 'en_US'
    result['vnc']['server_ip'].should == TEST_IP
    result['vnc']['active'].should be_true
    result['vnc']['password'].should_not be_nil
  end
  
  it "should be able to disable vnc boot status" do
    result = @h.disable_boot_vnc! TEST_IP
    result['vnc']['server_ip'].should == TEST_IP
    result['vnc']['active'].should be_false
    result['vnc']['password'].should be_nil
  end
end

describe "WOL" do
  before(:all) do
    @h = Hetzner::API.new(USERNAME, PASSWORD)
  end
  
  it "should be able to query WOL status" do
    result = @h.wol? TEST_IP
    result['wol']['server_ip'].should == TEST_IP
  end
  
  it "should be able to send a WOL notification" do
    result = @h.wol! TEST_IP
    result['wol']['server_ip'].should == TEST_IP
  end
end
