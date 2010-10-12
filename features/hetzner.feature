Feature: Hetzner
  In order to manage one or many dedicated servers at hetzner
  As a CLI
  I want to provider a decent, objective interface
  
  
  Scenario: Display available boot options for a specific server
    When I run "hetzner boot 11.11.11.111 --username='myusername' --password='mycoolpassword'"
    Then the output should contain "11.11.11.111"
    
  Scenario: Display the status of a failover IP
    When I run "hetzner failover 11.11.11.111 --username='myusername' --password='mycoolpassword'"
    Then the output should contain "11.11.11.111"
  
  Scenario: Update the failover delegation of an ip
    When I run "hetzner failover 11.11.11.111 --set --username='myusername' --password='mycoolpassword'"
    Then the output should contain "11.11.11.111"
        