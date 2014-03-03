#   Copyright 2014 Brainsware
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

Puppet::Type.newtype(:composer_project) do
  @doc = 'Innstall a project with composer and keep it up-todate'

  # # not sure if this is actually
  #
  # ensurable
  #
  # We'll need an ensurable parameter, which can either be
  # Can be either :present or :latest. :installed is a synonym for :present. Default: :present

  newparam(:name, :namevar => true) do
  end


  newproperty(:target) do
    desc 'target directory'
    defaultto resource[:name]
  end

  newproperty(:dev) do
    desc 'whether to install development packages'
    defaultto false
    # n.b.: This will need munging
  end

  newproperty(:scripts) do
    desc 'whether to execute scripts from the installed packages'
    defaultto true
    # n.b.: This will need munging
  end

  newproperty(:scripts) do
    desc 'whether to execute custom installers from the installed packages'
    defaultto true
    # n.b.: This will need munging
  end

  newproperty(:lock) do
    desc 'Only updates the lock file hash to suppress warning about the lock file being out of date'
    defaultto true
    # n.b.: This will need munging
    # also, this option only works when ensure => latest
  end

  newproperty(:prefer) do
    desc 'Which source to install packages from (source or dist)'
    defaultto :dist
    # n.b.: This will need munging (strings => symbols)
  end


end
