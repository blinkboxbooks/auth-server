@clients @deregistration @client_deregistration
Feature: Deregistering a client
  As a user
  I want to be able to de-register my client
  So that clients I no longer use/own are able to act on my behalf

  Background:
    Given I have registered an account
    And I have registered a client
    And I have bound my tokens to my client

  @smoke
  Scenario: Deregistering my current client, within critical elevation period
    Given I have a critically elevated access token
    When I request that my current client be deregistered
    Then the request succeeds
    And the critical elevation got extended

  @extremely_slow
  Scenario Outline: Deregistering my current client, outside critical elevation period
    Given I have <elevation_level> access token
    When I request that my current client be deregistered
    Then the request fails because I am unauthorised
    And the response includes low elevation level information

    Examples:
      | elevation_level |
      | an elevated     |
      | a non-elevated  |

  Scenario: Deregistering my current client, within critical elevation period
    Deregistering a client also revokes the tokens that are bound to that client, so if you deregister
    your current client then your tokens will no longer be valid.

    When I request that my current client be deregistered
    Then the request succeeds
    And my refresh token and access token are invalid because they have been revoked
    And I have no registered clients

  @extremely_slow
  Scenario Outline: Deregistering my current client, outside critical elevation period
    Deregistering a client also revokes the tokens that are bound to that client, so if you deregister
    your current client then your tokens will no longer be valid.

    Given I have <elevation_level> access token
    When I request that my current client be deregistered
    Then the request fails because I am unauthorised
    And the response includes low elevation level information

    Examples:
      | elevation_level |
      | an elevated     |
      | a non-elevated  |

  Scenario: Deregistering one of my other clients, within critical elevation period
    If you deregister another client though, it has no effect on your tokens. This is because the
    other client is a separate concern, and you might be deregistering it because it was lost or
    stolen from another legitimate client that you don't want to be signed out of.

    Given I have registered another client
    And I have a critically elevated access token
    When I request that my other client be deregistered
    Then the request succeeds
    And my refresh token and access token are valid
    And I have got one registered client
    And the critical elevation got extended

  @extremely_slow
  Scenario Outline: Deregistering one of my other clients, outside critical elevation period
    If you deregister another client though, it has no effect on your tokens. This is because the
    other client is a separate concern, and you might be deregistering it because it was lost or
    stolen from another legitimate client that you don't want to be signed out of.

    Given I have registered another client
    And I have <elevation_level> access token
    When I request that my other client be deregistered
    Then the request fails because I am unauthorised
    And the response includes low elevation level information

    Examples:
      | elevation_level |
      | an elevated     |
      | a non-elevated  |

  Scenario: Trying to deregister a client without authorisation
    # RFC 6750 § 3.1:
    #   If the request lacks any authentication information (e.g., the client
    #   was unaware that authentication is necessary or attempted using an
    #   unsupported authentication method), the resource server SHOULD NOT
    #   include an error code or other error information.

    When I request that my current client be deregistered, without my access token
    Then the request fails because I am unauthorised
    And the response does not include any error information

  Scenario: Trying to deregister a nonexistent client
    Given I have a critically elevated access token
    When I request that a nonexistent client be deregistered
    Then the request fails because the client was not found

  Scenario: Trying to deregister an already deregistered client
    Given I have a critically elevated access token
    And I have deregistered my current client
    When I request that my current client be deregistered
    Then the request fails because the client was not found

  Scenario: Trying to deregister another user's client
    For security reasons we don't distinguish between a client that doesn't exist and a client that
    does exist but the user isn't allowed to access. In either case we say it was not found.

    Given another user has registered an account
    And another user has registered a client
    When I request that the other user's client be deregistered
    Then the request fails because the client was not found

  Scenario: Deregistering a client after reaching the max amount of devices should allow you to register a new client
    Given I have a critically elevated access token
    And I have registered 12 clients in total
    When I request that my current client be deregistered
    And I submit a client registration request
    Then the response contains client information, including a client secret
    And the critical elevation got extended

  Scenario: Dissallow deregistered clients to log on with their old password and credentials
    Given I have deregistered my current client
    When I provide my email address, password and client credentials
    And I submit the authentication request
    Then the response indicates that the client credentials are incorrect
