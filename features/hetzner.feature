Feature: Hetzner
  In order to manage one or many dedicated servers at hetzner
  As a CLI
  I want to provider a decent, objective interface
  
  Scenario: Display boot options for one server
    When I run "hetzner boot show 78.46.50.215 --username  --password "
    Then the output should contain "178.46.50.215"