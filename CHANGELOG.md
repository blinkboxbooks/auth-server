# Zuul Server Change Log

## 0.17.1 ([#139](https://git.mobcastdev.com/Zuul/zuul-server/pull/139) 2015-01-23 11:32:35)

Reduce chance of developer not using thin

patch

## 0.17.0 ([#138](https://git.mobcastdev.com/Zuul/zuul-server/pull/138) 2014-12-16 17:17:12)

Updated the auth server to use Graylog

### New features

- Logs all messages to Graylog instead of to log files

### Notes

- Removed the logging of timing information to files as we now get this
from New Relic.

## 0.16.0 ([#137](https://git.mobcastdev.com/Zuul/zuul-server/pull/137) 2014-12-03 11:44:25)

Added identifiers to #sendEmail message

### New features

- Now sends the user identifier in the #sendEmail message as this is
required by ExactTarget to send mails via the API.

## 0.15.7 ([#136](https://git.mobcastdev.com/Zuul/zuul-server/pull/136) 2014-10-24 15:40:15)

CP-1998: Fixed an intermittent bug where user_details where not there

### Bug fixes

- `after_created` would be called regardless of whether the entity was saved or not. That would send a reporting message before the actual data has been committed to the database.

## 0.15.6 ([#135](https://git.mobcastdev.com/Zuul/zuul-server/pull/135) 2014-10-20 12:05:44)

Bugfix newrelic config and feature addition for new environments

Bug fix newrelic config

## 0.15.5 ([#134](https://git.mobcastdev.com/Zuul/zuul-server/pull/134) 2014-10-16 10:58:52)

Date/Expires date format changes

### Bug fixes

- The Date and Expires headers are now returned in the correct HTTP
date format.

## 0.15.4 ([#133](https://git.mobcastdev.com/Zuul/zuul-server/pull/133) 2014-10-16 10:00:41)

Database reconnects when disconnected

### Bug fixes

- Now automatically reconnects to the database if the connection is
dropped (e.g. by the database being restarted).

## 0.15.3 ([#132](https://git.mobcastdev.com/Zuul/zuul-server/pull/132) 2014-10-14 12:40:50)

Fix to SSO proxying to forward emails with a different case to forwarded_domains

#### Patch
* Ensuring both `@forwarded_domains` and the user's email address are downcase so forwarding by email address is no longer case sensitive.



## 0.15.2 ([#129](https://git.mobcastdev.com/Zuul/zuul-server/pull/129) 2014-09-05 09:23:05)

Fix tests

#### Test improvement to fix some of the test failures when running out of process against DevInt
* Clearing the HTTParty proxy. This issue was highlighted when a preceding test used (the currently blocked) wonderproxy.com, the following tests would use the same proxy unintentionally since the proxy was not being cleared on initialisation.  
* Ignoring some tests/steps when running out of process because they rely on the server running in-process, and having the SendsMessagetoFakeQueues module loaded in.
* Fixing some failing tests due to a bug in cucumber where the Background doesn't get run for a Scenario Outline when the Scenario Outline is not first. The fix is currently in a beta version of cucumber, see https://github.com/cucumber/cucumber/issues/560

## 0.15.1 ([#131](https://git.mobcastdev.com/Zuul/zuul-server/pull/131) 2014-09-24 15:03:36)

Fix forwarding logic for SSO delegation

### Bugfix

This patch will fix issues caused my lack of ruby-magic and will allow zuul to correctly delegate some requests to another server (i.e. auth-service) based on the provided configuration.

## 0.15.0 ([#130](https://git.mobcastdev.com/Zuul/zuul-server/pull/130) 2014-09-19 14:55:19)

Introduce better settings for sso forwarding

### New feature

* Allow the configuration of which username domains have to be forwarded to another service for authentication.

## 0.14.0 ([#128](https://git.mobcastdev.com/Zuul/zuul-server/pull/128) 2014-08-18 15:25:51)

Added the ability to proxy SSO requests

### New features

- Can now proxy requests from employees to a delegate auth server

## 0.13.9 ([#127](https://git.mobcastdev.com/Zuul/zuul-server/pull/127) 2014-08-18 12:22:30)

Patch for running against DevInt on CI

Patch for running against DevInt on CI:

* Simplify and merge cucumber.yml config files
* Empty results/ folder so CI jobs don't complain when ran
* Don't run steps that rely on in-process monkey-patching when targeting external instances
* Some minor whitespace cleanup

## 0.13.8 ([#126](https://git.mobcastdev.com/Zuul/zuul-server/pull/126) 2014-08-06 11:16:35)

Update cucumber config

Test improvement - new cucumber profiles
This change is so we can run the tests out of process against the DevInt environment


## 0.13.7 ([#121](https://git.mobcastdev.com/Zuul/zuul-server/pull/121) 2014-08-01 10:52:54)

Application & Reference Config; specify keys directory

### Improvements

- Moved configuration to `config/reference.properties` (for sane defaults) and `config/application.properties` (for environment specific settings)
- Included a `config/testing.properties` for the test environment (The application being tested will still load `config/application.properties`!)
- Added new config `auth.keysPath` which is the location where keys should be searched for.

## 0.13.6 ([#125](https://git.mobcastdev.com/Zuul/zuul-server/pull/125) 2014-08-04 10:29:12)

New Relic Log file location

### Improvement

- Moved the location of the new relic logfile to an ops-approved location.

## 0.13.5 ([#124](https://git.mobcastdev.com/Zuul/zuul-server/pull/124) 2014-08-04 08:52:25)

No need for MySQL2 adapter

### Improvements

- Don't need the MySQL2 adapter gem listed explicitly any more.

## 0.13.4 ([#123](https://git.mobcastdev.com/Zuul/zuul-server/pull/123) 2014-08-04 08:39:48)

HA! You little bastard. You depend on MySQL shared libraries

### Bug fix

- We need to make sure the RPM depends on the shared MySQL libraries. Woop!

## 0.13.3 ([#122](https://git.mobcastdev.com/Zuul/zuul-server/pull/122) 2014-08-01 18:11:51)

Added MySQL2 adapter

### Bug fix

- Need the activerecord-mysql2-adapter gem for RPM deployment

## 0.13.2 ([#119](https://git.mobcastdev.com/Zuul/zuul-server/pull/119) 2014-07-29 11:19:12)

Removed sqlite3 dependency

### Improvements

- Removed sqlite3 dependency as it isn't used and means the CI server configuration would need to be changed to support it if we keep it.

## 0.13.1 ([#105](https://git.mobcastdev.com/Zuul/zuul-server/pull/105) 2014-07-21 08:25:22)

Use percent

### Bug fix

- Use percent instead of dollar in spec files!

## 0.13.0 ([#103](https://git.mobcastdev.com/Zuul/zuul-server/pull/103) 2014-07-18 15:06:38)

Prepare for RPM building

### New Feature

- Allows building RPMs!

![Everything is awesome](http://media.giphy.com/media/Z6f7vzq3iP6Mw/giphy.gif)

## 0.12.1 ([#99](https://git.mobcastdev.com/Zuul/zuul-server/pull/99) 2014-07-03 10:44:16)

Updated README

### Improvement

- updated README

## 0.12.0 ([#98](https://git.mobcastdev.com/Zuul/zuul-server/pull/98) 2014-06-30 16:18:52)

New Relic integration

### New Feature

- Added first-stage New Relic integration.
- Upgraded to using Artifactory for gems.

## 0.11.7 (2014-02-28 18:52)

## Bug Fixes

- [CP-1217](https://tools.mobcastdev.com/jira/browse/CP-1217): Unsigned tokens cannot be used to authenticate.

## 0.11.6 (2014-02-14 17:17)

## Bug Fixes

- [CP-1096](https://tools.mobcastdev.com/jira/browse/CP-1096): Fixed an issue where a user registration with a client will resulting in publishing a reporting message without a user_id for the respective client.

## 0.11.5 (2014-02-13 15:47)

### Bug Fixes

- Fix an issue with the 0.11.3 deployment script which removed some roles from the super user instead of adding to them

## ~~0.11.4 (2014-02-13 15:24)~~

_There is an issue with a DB deployment script in this release. Don't use it._

### Bug Fixes

- [CP-1141](https://tools.mobcastdev.com/jira/browse/CP-1141): Fixed incorrect content-type return value on some routes (inc `/session`)

## ~~0.11.3 (2014-02-13 10:40)~~

_There is an issue with returned media types and a DB deployment script in this release. Don't use it._

### Improvements

- Added 'mer' (Merchandising) and 'mkt' (Marketing) roles.
- Added non-null constraints to roles/privileges tables.

### Deployment Notes

- A database migration to schema version 12 is required.

## ~~0.11.2 (2014-02-11 09:22)~~

_There is an issue with returned media types in this release. Don't use it._

### Improvements

- Removed dependency on MultiJson in favour of built-in JSON library.

## 0.11.1 (2014-02-10 18:10)

### Bug Fixes

- [CP-1108](https://tools.mobcastdev.com/jira/browse/CP-1108) - Registering users is now insensitive to the case of the email address.

## 0.11.0 (2014-01-23 18:12)

### New Features

- [CP-1044](https://tools.mobcastdev.com/jira/browse/CP-1044) - Authenticated events are now sent when a user authenticates to the server.

## 0.10.3 (2014-01-29 15:20)

### Bug Fixes

- Cucumber and RSpec dependencies are now lazily loaded by the Rakefile so that it can deploy successfully without development/test dependencies.

## 0.10.2 (2014-01-23 14:28)

### New Features

- [CP-911](https://tools.mobcastdev.com/jira/browse/CP-911) - Administrative retrieval of user information by identifier is now supported.

## 0.10.1 (2014-01-22 17:55)

### Bug Fixes

- [CP-988](https://tools.mobcastdev.com/jira/browse/CP-988) - Timing is now correct for throttled login attempts (was too long by up to 1 second).

## 0.10.0 (2014-01-21 09:58)

### New Features

- [CP-910](https://tools.mobcastdev.com/jira/browse/CP-910) - Administrative search for users is now supported by username, first and last name, or user id.
- Username change history is now recorded, to support user search by previous username (i.e. the search returns any user who has ever had that username).

### Deployment Notes

- A database migration to schema version 10 is required.

## 0.9.0 (2014-01-16 14:57)

### New Features

- [CP-557](https://tools.mobcastdev.com/jira/browse/CP-557) - Users can now be associated with roles, which are returned in the token and in session info.

### Deployment Notes

- A database migration to schema version 9 is required.

## 0.8.2 (2014-01-14 12:28)

### Improvements

- [CP-990](https://tools.mobcastdev.com/jira/browse/CP-990):
    - Using simpler XML schema for reporting
    - Switched from fanout to topic exchange with routing key

## 0.8.1 (2014-01-13 18:25)

### New Features

- [CP-968](https://tools.mobcastdev.com/jira/browse/CP-968) - Auth server now logs errors and warnings to file in JSON format.

### Deployment Notes

- Two new properties are required in the properties file:
    - `logging.error.file` - The error log file.
    - `logging.error.level` - The error log level.

## 0.8.0 (2014-01-07 10:29)

### New Features

- [CP-313](https://tools.mobcastdev.com/jira/browse/CP-313) - Failed attempts to authenticate or change password are now throttled to 5 consecutive failures within a 20 second period.

### Bug Fixes

- Fixed an (unreported) timing bug in user authentication where no password hashing was done for unregistered email addresses, meaning that it would be possible to check whether an address was registered by inspecting the response time.

### Deployment Notes

- A database migration to schema version 8 is required.

## 0.7.2 (2013-12-23 11:00)

### New Features

- [CP-920](https://tools.mobcastdev.com/jira/browse/CP-920) - Reporting support for user and client events.

## 0.7.1 (2013-12-18 14:06)

### New Features

- [CP-907](https://tools.mobcastdev.com/jira/browse/CP-907) - Performance logger now logs array of client IPs including `X-Forwarded-For` header information.

## 0.7.0 (2013-12-11 17:15)

### New Features

- [CP-872](https://tools.mobcastdev.com/jira/browse/CP-872) - Performance information for requests is now logged.

### Deployment Notes

- New properties are required in the properties file:
    - `logging.perf.file` - The performance log file.
    - `logging.perf.level` - The performance log level.
    - `logging.perf.threshold.error` - The threshold (in ms) for performance error logs.
    - `logging.perf.threshold.warn` - The threshold (in ms) for performance warning logs.
    - `logging.perf.threshold.info` - The threshold (in ms) for performance info logs.

## 0.6.2 (2013-11-06 15:51)

### Bug Fixes

- [CP-765](https://tools.mobcastdev.com/jira/browse/CP-765) - Fixed a false positive test so now the server should return a client secret when using combined user and client registration.

## 0.6.1 (2013-11-05 19:28)

### Bug Fixes

- [CP-581](https://tools.mobcastdev.com/jira/browse/CP-581) - Fixed a bug where we wouldn't extend the elevation period right after an action that required elevation.
    - Refactored the elevation checks along with the extension in a sinatra filter (before and after).
    - Added constants for elevation expiry timespans.

## 0.6.0 (2013-11-05 09:54)

### New Features

- [CP-714](https://tools.mobcastdev.com/jira/browse/CP-714) - Adding simultaneous user and client registrations. The implication of which are as follows:
    - From now on, client registration will require all fields, which are os, model, name and brand.
    - The old user registration works as before, however, if client info is added to the request, it will trigger both a user registration and client registration.
    - User registration is now done as an SQL transaction, meaning that if user registration or client registration fails, neither will be created in our database.

## 0.5.3 (2013-11-01 14:54)

### Bug Fixes

- [CP-581](https://tools.mobcastdev.com/jira/browse/CP-581) - Personal information can only be retrieved when user is critically elevated
- [CP-720](https://tools.mobcastdev.com/jira/browse/CP-720) - Corrected auth server WWW-Authenticate headers
- Fixed a bug where PATCH request on /users/{user_id} wouldn't check for critical elevation level
- Fixed a bug where POST request on /clients wouldn't check for critical elevation level
- Fixed a bug where PATCH or DELETE requests on /clients/{client_id} wouldn't check for critical elevation level

## 0.5.2 (2013-10-23 13:52)

### Bug Fixes

- [CP-722](https://tools.mobcastdev.com/jira/browse/CP-722) - Do not allow deregisterd clients to log in with their old credentials

## 0.5.1 (2013-10-23 13:52)

### Bug Fixes

- [CP-692](https://tools.mobcastdev.com/jira/browse/CP-692) - We can now deregister from maximum amount of clients, i.e. we add a new client after a deregistration of an old client.

## 0.5.0 (2013-10-15 13:45)

### Breaking Changes

- `PATCH /clients/{id}` and `PATCH /users/{id}` now return `400 Bad Request` instead of `200 OK` if no valid updateable attributes are specified.

### New Features

- [CP-490](https://tools.mobcastdev.com/jira/browse/CP-490) - A password changed confirmation email is sent on successful password change.
- [CP-632](https://tools.mobcastdev.com/jira/browse/CP-632) - Clients now have `client_brand` and `client_os` details, which are optional on registration and updates.

### Deployment Notes

- A database migration to schema version 7 is required.

## 0.4.1 (2013-10-11 16:01)

### Bug Fixes

- [CP-607](https://tools.mobcastdev.com/jira/browse/CP-607) - Empty bearer tokens now have an `invalid_token` error code.

## 0.4.0 (2013-10-10 12:52)

### Breaking Changes

- Endpoint `/tokeninfo` has been renamed to `/session`.

### New Features

- [CP-482](https://tools.mobcastdev.com/jira/browse/CP-482) - A welcome email is sent when a new user registers successfully.

### Bug Fixes

- Password reset link format now matches what the website is expecting in example properties files.

## 0.3.0 (2013-10-07 12:32)

### New Features

- [CP-314](https://tools.mobcastdev.com/jira/browse/CP-314) - Password reset functionality is now available. The end-to-end flow relies on the mailer service.
    - New endpoint `POST /password/reset` to allow a user to request a password reset email.
    - New endpoint `POST /password/reset/validate-token` to allow validation of a password reset token prior to trying to reset using it.
    - Endpoint `POST /oauth2/token` supports new grant type `urn:blinkbox:oauth:grant-type:password-reset-token` to allow a user to reset their password and authenticate using a reset token.

### Bug Fixes

- Fixed an issue where error descriptions were being returned in the `error_reason` field instead of `error_description`.
- Fixed an issue where the time a client was last used was not being updated in the password authentication flow.

### Deployment Notes

- A database migration to schema version 6 is required.
- New properties are required in the properties file:
    - `password_reset_url` - The password reset URL template.
    - `amqp_server_url` - The connection string to the AMQP server.

## 0.2.0 (2013-10-01 13:57)

### New Features

- [CP-552](https://tools.mobcastdev.com/jira/browse/CP-552) New endpoint `POST /password/change` to allow users to change their password.

## 0.1.0 (Baseline Release)

Baseline release from which the change log was started. Database schema version should be 5 at this point.
