#   Copyright 2017 Brainsware
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

describe 'composer', type: :class do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'it should install composer' do
          let(:title) { 'composer' }

          it do
            is_expected.to contain_archive('composer-install'). \
              with_source('https://getcomposer.org/composer.phar'). \
              with_user('root'). \
              with_path('/usr/local/bin/composer')
          end

          it do
            is_expected.to contain_file('composer-fix-permissions'). \
              with_path('/usr/local/bin/composer'). \
              with_mode('0755') \
          end

          it { is_expected.not_to contain_exec('composer-update') }
        end

        context 'with a given target_dir' do
          let(:params) { { target_dir: '/usr/bin' } }

          it do
            is_expected.to contain_archive('composer-install'). \
              with_source('https://getcomposer.org/composer.phar'). \
              with_user('root'). \
              with_path('/usr/bin/composer')
          end

          it do
            is_expected.to contain_file('composer-fix-permissions'). \
              with_mode('0755'). \
              with_path('/usr/bin/composer')
          end

          it { is_expected.not_to contain_exec('composer-update') }
        end

        context 'with a given command_name' do
          let(:params) { { command_name: 'c' } }

          it do
            is_expected.to contain_archive('composer-install'). \
              with_source('https://getcomposer.org/composer.phar'). \
              with_user('root'). \
              with_path('/usr/local/bin/c')
          end

          it do
            is_expected.to contain_file('composer-fix-permissions'). \
              with_mode('0755'). \
              with_path('/usr/local/bin/c')
          end

          it { is_expected.not_to contain_exec('composer-update') }
        end

        context 'with auto_update => true' do
          let(:params) { { auto_update: true } }

          it do
            is_expected.to contain_archive('composer-install'). \
              with_source('https://getcomposer.org/composer.phar'). \
              with_user('root'). \
              with_path('/usr/local/bin/composer')
          end

          it do
            is_expected.to contain_file('composer-fix-permissions'). \
              with_mode('0755'). \
              with_path('/usr/local/bin/composer')
          end

          it do
            is_expected.to contain_exec('composer-update'). \
              with_command('composer self-update'). \
              with_user('root'). \
              with_path('/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin')
          end
        end

        context 'with a given user' do
          let(:params) { { user: 'will' } }

          it do
            is_expected.to contain_archive('composer-install'). \
              with_source('https://getcomposer.org/composer.phar'). \
              with_user('will'). \
              with_path('/usr/local/bin/composer')
          end

          it do
            is_expected.to contain_file('composer-fix-permissions'). \
              with_mode('0755'). \
              with_path('/usr/local/bin/composer')
          end

          it { is_expected.not_to contain_exec('composer-update') }
        end

        context 'with provider set to package' do
          let(:params) { { provider: 'package' } }

          it { is_expected.not_to contain_archive('composer-install') }
          it do
            is_expected.to contain_package('composer-install'). \
              with_name('php-composer'). \
              with_ensure('present')
          end
        end

        context 'with provider package, and auto_update' do
          let(:params) { { provider: 'package', auto_update: true } }

          it { is_expected.not_to contain_archive('composer-install') }
          it do
            is_expected.to contain_package('composer-install'). \
              with_name('php-composer'). \
              with_ensure('latest')
          end
        end

        context 'with provider package, and custom package name' do
          let(:params) { { provider: 'package', package: 'php5-composer' } }

          it { is_expected.not_to contain_archive('composer-install') }
          it do
            is_expected.to contain_package('composer-install'). \
              with_name('php5-composer'). \
              with_ensure('present')
          end
        end
      end
    end
  end
end
