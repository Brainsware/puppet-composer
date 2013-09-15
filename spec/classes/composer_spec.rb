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

require 'spec_helper'

describe 'composer', :type => :class do
  let(:title) { 'composer' }

  it { should contain_wget__fetch('composer-install') \
    .with_source('http://getcomposer.org/composer.phar') \
    .with_execuser('root') \
    .with_destination('/usr/local/bin/composer')
  }

  it { should contain_exec('composer-fix-permissions') \
    .with_command('chmod a+x composer') \
    .with_user('root') \
    .with_cwd('/usr/local/bin')
  }

  it { should_not contain_exec('composer-update') }

  describe 'with a given target_dir' do
    let(:params) {{ :target_dir => '/usr/bin' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('http://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/bin/composer')
    }

    it { should contain_exec('composer-fix-permissions') \
      .with_command('chmod a+x composer') \
      .with_user('root') \
      .with_cwd('/usr/bin')
    }

    it { should_not contain_exec('composer-update') }
  end

  describe 'with a given command_name' do
    let(:params) {{ :command_name => 'c' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('http://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/local/bin/c')
    }

    it { should contain_exec('composer-fix-permissions') \
      .with_command('chmod a+x c') \
      .with_user('root') \
      .with_cwd('/usr/local/bin')
    }

    it { should_not contain_exec('composer-update') }
  end

  describe 'with auto_update => true' do
    let(:params) {{ :auto_update => true }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('http://getcomposer.org/composer.phar') \
      .with_execuser('root') \
      .with_destination('/usr/local/bin/composer')
    }

    it { should contain_exec('composer-fix-permissions') \
      .with_command('chmod a+x composer') \
      .with_user('root') \
      .with_cwd('/usr/local/bin')
    }

    it { should contain_exec('composer-update') \
      .with_command('composer self-update') \
      .with_user('root') \
      .with_path('/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin')
    }
  end

  describe 'with a given user' do
    let(:params) {{ :user => 'will' }}

    it { should contain_wget__fetch('composer-install') \
      .with_source('http://getcomposer.org/composer.phar') \
      .with_execuser('will') \
      .with_destination('/usr/local/bin/composer')
    }

    it { should contain_exec('composer-fix-permissions') \
      .with_command('chmod a+x composer') \
      .with_user('will') \
      .with_cwd('/usr/local/bin')
    }

    it { should_not contain_exec('composer-update') }
  end

  describe 'with provider set to package' do
    let(:params) {{ :provider => 'package' }}

    it { should_not contain_wget__fetch('composer-install') }
    it { should contain_package('composer-install') \
         .with_name('php-composer') \
         .with_ensure('present')
    }
  end

  describe 'with provider package, and auto_update' do
    let(:params) {{ :provider => 'package', :auto_update => true }}

    it { should_not contain_wget__fetch('composer-install') }
    it { should contain_package('composer-install') \
         .with_name('php-composer') \
         .with_ensure('latest')
    }
  end

  describe 'with provider package, and custom package name' do
    let(:params) {{ :provider => 'package', :package => 'php5-composer' }}

    it { should_not contain_wget__fetch('composer-install') }
    it { should contain_package('composer-install') \
         .with_name('php5-composer') \
         .with_ensure('present')
    }
  end
end
