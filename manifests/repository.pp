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

# = Defined Type composer::repository
#
#  This defined type allows for managing composer repositories
#
# == Parameters:
#
# [*ensure*]
#   Can be either 'present' or 'absent'. Default: present
#
# [*type*]
#   Type of the composer repository. Default: undef
#
# [*url*]
#   URL of the composer repository. Default: undef
#
# [*target*]
#   Where to add this composer repository. Must exist if set! Defaults to undef
#
# [*global*]
#   Toggles whether to manage the repository globally. Default: false
#
# [*user*]
#   The owner of the repository. Default: 'root'
#

define composer::repository (
  $ensure = present,
  $type   = undef,
  $url    = undef,
  $target = undef,
  $global = false,
  $user   = 'root',
) {
  include composer

  validate_re($ensure, '^(present|absent)$', 'composer::repository::ensure must be one of present or absent.')
  validate_re($type, '^(composer|vcs|pear|package)$', 'composer::repository::type must be one of composer, vcs, pear or package.')
  validate_bool($global)

  if !$url {
    fail('composer::repository::url must be set')
  }

  if !$target and !$global {
    fail('Either composer::repository::target or composer::repository::global must be set')
  }

  $composer  = "${composer::target_dir}/${composer::command_name}"
  $global_opt = $global ? {
    true  => '--global',
    false => '',
  }
  $unset_opt = $ensure ? {
    'present' => '',
    'absent'  => '--unset',
  }

  $user_home = $user ? {
    'root'  => ['HOME=/root'],
    default => ["HOME=/home/${user}"],
  }

  if $composer::home {
    $composer_home = ["COMPOSER_HOME=${composer::home}"]
  } else {
    $composer_home = []
  }

  $environment = concat(
    $user_home,
    $composer_home
  )

  Exec {
    cwd         => $target,
    path        => $::path,
    provider    => 'posix',
    user        => $user,
    environment => $environment,
    require     => Class['composer'],
  }

  # Escape RegExp meta characters in URLs
  $escaped_url = regsubst($url, '([.?])', '\\\\\1', 'G')

  exec { "composer_repository_${title}":
    command => "${composer} config ${global_opt} ${unset_opt} repositories.${title} ${type} ${url}",
    unless  => "${composer} config ${global_opt} --list --no-ansi | grep -E '\\[repositories\\.${title}\\.type\\] ${type}$' && ${composer} config ${global_opt} --list --no-ansi | grep -E '\\[repositories\\.${title}\\.url\\] ${escaped_url}$'",
  }
}
