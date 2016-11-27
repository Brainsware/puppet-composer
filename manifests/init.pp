#   Copyright 2016 Brainsware
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
# [*source*]
#   The (default) source to download composer from.
#
# [*user*]
#   The owner of the composer executable.
#
# [*home*]
#   The composer home directory. Defaults to undef
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
  $provider     = 'archive',
  $target_dir   = '/usr/local/bin',
  $command_name = 'composer',
  $package      = 'php-composer',
  $source       = 'https://getcomposer.org/composer.phar',
  $user         = 'root',
  $home         = undef,
  $auto_update  = false,
) {

  $install_class = $provider? {
    /^(archive|package)$/ => "composer::install::${provider}",
    default               => $provider,
  }

  contain $install_class
}
