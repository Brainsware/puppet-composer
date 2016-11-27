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

# = Class: composer::install::archive
#
#  This private class helps install composer by downloading it directly from their website
#
# == Parameters:
#
#  none
#
class composer::install::archive {

  archive { 'composer-install':
    source => $::composer::source,
    path   => "${::composer::target_dir}/${::composer::command_name}",
    user   => $::composer::user,
  } ~>
  file { 'composer-fix-permissions':
    path => "${::composer::target_dir}/${::composer::command_name}",
    mode => '0755',
  }

  if $::composer::auto_update {
    exec { 'composer-update':
      command => "${::composer::command_name} self-update",
      path    => "${::composer::target_dir}:/usr/bin:/bin:/usr/sbin:/sbin",
      user    => $::composer::user,
      require => File['composer-fix-permissions'],
    }
  }
}
