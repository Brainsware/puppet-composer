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

all:
	@echo 'You need to specifically call this as'
	@echo
	@echo '    % make release'
	@echo
	@echo 'Please note that the release target is not idempotent.'
	@echo
	@exit 1

export v = $(shell awk -F"'" '/\<version\>/{print $$2}' Modulefile)

release:
	git tag -s $(v) -m 't&r $(v)'
	git checkout $(v)
	puppet module build .
