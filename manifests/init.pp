#   Copyright 2013 Brainsware
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# = Class: composer
#
# == Parameters:
#
# [*provider*]
#   Can be set to package, if so, please provide a *package* name.
#
# [*target_dir*]
#   Where to install the composer executable.
#
# [*command_name*]
#   The name of the composer executable.
#
# [*package*]
#   The name of the composer package.
#
# [*user*]
#   The owner of the composer executable.
#
# [*auto_update*]
#   Whether to run `composer self-update`. In the case of package whether to `ensure => latest`.
#
# == Example:
#
#   include composer
#
#   class { 'composer':
#     'target_dir'   => '/usr/local/bin',
#     'user'         => 'root',
#     'command_name' => 'composer',
#     'auto_update'  => true
#   }
#
class composer (
  $provider     = $composer::params::provider,
  $target_dir   = $composer::params::target_dir,
  $command_name = $composer::params::command_name,
  $package      = $composer::params::package,
  $user         = $composer::params::user,
  $auto_update  = $composer::params::auto_update
) inherits composer::params {

  validate_re($provider, '^(wget|package)$', 'Please make sure to set $provider one of "wget" or "package".')

  class { "composer::install::${provider}":
    target_dir   => $target_dir,
    command_name => $command_name,
    package      => $package,
    user         => $user,
    auto_update  => $auto_update,
  }
}
