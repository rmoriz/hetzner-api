Feature: Hetzner
  In order to manage one or many dedicated servers at hetzner
  As a CLI
  I want to provider a decent, objective interface
  
  Scenario: Display boot options for one server
    When I run "hetzner boot get 11.11.11.111 --username='myusername' --password='mycoolpassword'"
    Then the output should contain "11.11.11.111"