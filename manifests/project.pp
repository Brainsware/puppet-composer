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

# = Defined Type composer::project
#
#  This defined type helps install a project with composer and keep it up-todate
#
# == Parameters:
#
# [*ensure*]
#   Can be either 'present' or 'latest'. 'installed' is a synonym for 'present'. Default: present
#
# [*target*]
#   Where to install this composer project. Must exist! Defaults to $title
#
# [*dev*]
#   Toggle the installation of require-dev packages. Default: false
#
# [*scripts*]
#   Toggles the execution of all scripts defined in composer.json. Default: true
#
# [*custom_inst*]
#   Toggles the execution of all custom installers. Default: true
#
# [*prefer*]
#   Define a preference for either 'source' or 'dist' (package) distribution. Default: 'dist'
#
# [*lock*]
#   Toggles whether to update only the hash in composer.lock to avoid "out of date" warnings. Default: false
#

define composer::project (
  $ensure      = present,
  $target      = $title,
  $dev         = false,
  $prefer      = 'dist',
  $scripts     = true,
  $custom_inst = true,
  $lock        = false,
) {
  include composer

  validate_re($ensure, '^(present|installed|latest)$', '$ensure must be one of present or latest.')
  validate_re($prefer, '^(dist|source)$', '$prefer can only be one of source or dist. See `composer install --help`.')
  validate_bool($dev, $scripts, $custom_inst)

  $composer  = "${composer::target_dir}/${composer::command_name}"
  $base_opts = '--no-interaction --quiet --no-progress'

  $dev_opt = $dev? {
    true  => '--dev',
    false => '--no-dev',
  }
  $script_opt = $scripts? {
    true  => [],
    false => '--no-scripts',
  }
  $custom_inst_opt = $custom_inst? {
    true  => [],
    false => '--no-custom-installer',
  }
  $lock_opt = $lock? {
    false => [],
    true  => '--lock',
  }

  $install_opts = join(flatten([$dev_opt, $script_opt, $custom_inst_opt, "--prefer-${prefer}" ]), ' ')
  $update_opts = join(flatten([$dev_opt, $script_opt, $custom_inst_opt, "--prefer-${prefer}", $lock_opt ]), ' ')


  exec { "composer_install_${title}":
    command => "${composer} install ${base_opts} ${install_opts}",
    onlyif  => "${composer} install ${install_opts} --dry-run | grep -- '- Installing '",
    cwd     => $target,
    require => Class['composer'],
  }

  if $ensure == latest {
    exec { "composer_update_${title}":
      command => "${composer} update ${base_opts} ${update_opts}",
      onlyif  => "${composer} update ${update_opts} --dry-run | grep -- '- Installing '",
      cwd     => $target,
      path    => $::path,
      require => Class['composer'],
    }
  }
}
