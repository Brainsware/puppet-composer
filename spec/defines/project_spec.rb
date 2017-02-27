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

describe 'composer::project' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'it should create a project' do
          let(:title) { 'yolo' }
          let(:params) { { target: '/srv/web/yolo' } }

          it { is_expected.to contain_composer__project('yolo').with('ensure' => 'present') }
          it do
            is_expected.to contain_exec('composer_install_yolo').with('command' => '/usr/local/bin/composer install --no-interaction --quiet --no-progress --no-dev --prefer-dist',
                                                                      'cwd' => '/srv/web/yolo')
          end
        end

        context 'composer project with ensure => latest' do
          let(:title) { 'yolo' }
          let(:params) { { target: '/srv/web/yolo', ensure: 'latest' } }

          it { is_expected.to contain_composer__project('yolo').with('ensure' => 'latest') }
          it do
            is_expected.to contain_exec('composer_install_yolo').with('command' => '/usr/local/bin/composer install --no-interaction --quiet --no-progress --no-dev --prefer-dist',
                                                                      'cwd' => '/srv/web/yolo')
          end
          it do
            is_expected.to contain_exec('composer_update_yolo').with('command' => '/usr/local/bin/composer update --no-interaction --quiet --no-progress --no-dev --prefer-dist',
                                                                     'cwd' => '/srv/web/yolo')
          end
        end

        context 'Keep composer project up-to-date with dev dependencies' do
          let(:title) { 'yolo' }
          let(:params) { { target: '/srv/web/yolo', ensure: 'latest', dev: true } }

          it { is_expected.to contain_composer__project('yolo').with('ensure' => 'latest') }
          it do
            is_expected.to contain_exec('composer_install_yolo').with('command' => '/usr/local/bin/composer install --no-interaction --quiet --no-progress --dev --prefer-dist',
                                                                      'cwd' => '/srv/web/yolo')
          end
          it do
            is_expected.to contain_exec('composer_update_yolo').with('command' => '/usr/local/bin/composer update --no-interaction --quiet --no-progress --dev --prefer-dist',
                                                                     'cwd' => '/srv/web/yolo')
          end
        end

        context 'Keep composer project up-to-date with dev dependencies, ignoring composer.lock' do
          let(:title) { 'yolo' }
          let(:params) { { target: '/srv/web/yolo', ensure: 'latest', dev: true, lock: true } }

          it { is_expected.to contain_composer__project('yolo').with('ensure' => 'latest') }
          it do
            is_expected.to contain_exec('composer_install_yolo').with('command' => '/usr/local/bin/composer install --no-interaction --quiet --no-progress --dev --prefer-dist',
                                                                      'cwd' => '/srv/web/yolo')
          end
          it do
            is_expected.to contain_exec('composer_update_yolo').with('command' => '/usr/local/bin/composer update --no-interaction --quiet --no-progress --dev --prefer-dist --lock',
                                                                     'cwd' => '/srv/web/yolo')
          end
        end

        context 'Create project from source' do
          let(:title) { 'yolo' }
          let(:params) { { target: '/srv/web/yolo', ensure: 'present', source: 'foo/bar' } }

          it { is_expected.to contain_composer__project('yolo').with('ensure' => 'present') }
          it do
            is_expected.to contain_exec('composer_create_project_yolo').with('command' => '/usr/local/bin/composer create-project --no-interaction --quiet --no-progress --no-dev --prefer-dist --keep-vcs foo/bar .',
                                                                             'creates' => '/srv/web/yolo/composer.json',
                                                                             'cwd'     => '/srv/web/yolo')
          end
          it do
            is_expected.to contain_exec('composer_install_yolo').with('command' => '/usr/local/bin/composer install --no-interaction --quiet --no-progress --no-dev --prefer-dist',
                                                                      'cwd' => '/srv/web/yolo')
          end
        end
      end
    end
  end
end
