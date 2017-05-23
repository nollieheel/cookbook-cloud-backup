## 0.4.0 - 2017-05-17
### Added
- Attributes 'pre_renew_cmds' and 'post_renew_cmds' for custom script commands before and after the cert renew process, respectively.
- Attribute 'webserver_service' can now be set to false to disable stopping and starting of any service in the script.

## 0.3.1 - 2016-01-04
- Update metadata.rb to correct value.

## 0.3.0 - 2016-12-29 [YANKED]
### Changed
- Moved the 'obtain_certs' and 'test' attributes to the individual config hashes to make it more flexible. Each hash in the 'config' attribute can now have the `:test` and/or `:get_cert` property/ies (both default to `true` if not given).

## 0.2.1 - 2016-12-21
### Added
- Add an attribute that controls whether or not certificates are obtained from LE api.
- Add some echo feedback to auto-renew script, in case it is run manually.

### Changed
- recipes/get_certs.rb: If certs are to be obtained, make sure an attempt is made regardless of whether the LE config template is update/created or not.

# 0.2.0

Allow option to run some bash commands right after renewal

# 0.1.2

Add distribution attribute to apt_repository resource

# 0.1.1

Remove -v flag from sendmail call

# 0.1.0

Initial release of cookbook-letsencrypt
