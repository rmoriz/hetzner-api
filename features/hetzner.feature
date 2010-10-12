Feature: Hetzner
  In order to manage one or many dedicated servers at hetzner
  As a CLI
  I want to provider a decent, objective interface
  
  
  Scenario: Display available boot options for a specific server
    When I run "hetzner boot 11.11.11.111 --username='myusername' --password='mycoolpassword'"
    Then the output should contain "11.11.11.111"
    
  Scenario: Display the status of all failover IPs
    When I run "hetzner failover --username='myusername' --password='mycoolpassword'"
    Then the output should contain "active_server_ip"
      
  Scenario: Display the status of a failover IP
    When I run "hetzner failover 11.11.11.111 --username='myusername' --password='mycoolpassword'"
    Then the output should contain "11.11.11.111"
  
  Scenario: Update the failover delegation of an ip
    When I run "hetzner failover 22.22.22.222 --to 11.11.11.112 --username='myusername' --password='mycoolpassword'"
    Then the output should contain "active_server_ip"
        