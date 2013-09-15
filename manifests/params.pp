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

# = Class: composer::params
#
# This class defines default parameters used by the main module class composer.
# Operating Systems differences in names and paths are addressed here.
#
# == Variables:
#
# Refer to composer class for the variables defined here.
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
class composer::params {
  $provider      = 'wget'
  $phar_location = 'http://getcomposer.org/composer.phar'
  $target_dir    = '/usr/local/bin'
  $command_name  = 'composer'
  $user          = 'root'
  $auto_update   = false
  $package       = 'php-composer'
}
