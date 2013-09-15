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
# [*target_dir*]
#   Where to install the composer executable.
#
# [*command_name*]
#   The name of the composer executable.
#
# [*user*]
#   The owner of the composer executable.
#
# [*auto_update*]
#   Whether to run `composer self-update`.
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
  $provider     = undef,
  $target_dir   = undef,
  $command_name = undef,
  $user         = undef,
  $auto_update  = false
) {

  include composer::params

  $composer_target_dir = $target_dir ? {
    undef => $::composer::params::target_dir,
    default => $target_dir
  }

  $composer_command_name = $command_name ? {
    undef => $::composer::params::command_name,
    default => $command_name
  }

  $composer_user = $user ? {
    undef => $::composer::params::user,
    default => $user
  }

  wget::fetch { 'composer-install':
    source      => $::composer::params::phar_location,
    destination => "${composer_target_dir}/${composer_command_name}",
    execuser    => $composer_user,
  }

  exec { 'composer-fix-permissions':
    command => "chmod a+x ${composer_command_name}",
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => $composer_target_dir,
    user    => $composer_user,
    unless  => "test -x ${composer_target_dir}/${composer_command_name}",
    require => Wget::Fetch['composer-install'],
  }

  if $auto_update {
    exec { 'composer-update':
      command => "${composer_command_name} self-update",
      path    => "/usr/bin:/bin:/usr/sbin:/sbin:${composer_target_dir}",
      user    => $composer_user,
      require => Exec['composer-fix-permissions'],
    }
  }
}
