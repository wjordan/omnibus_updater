#
# Cookbook Name:: omnibus_updater
# Attributes:: default
#
# Copyright 2014, Heavy Water Ops, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:omnibus_updater][:install_sh][:enabled] = false
default[:omnibus_updater][:install_sh][:url] = 'https://www.getchef.com/chef/install.sh'
default[:omnibus_updater][:install_sh][:script_options] = {}
default[:omnibus_updater][:version] = nil
default[:omnibus_updater][:force_latest] = false
default[:omnibus_updater][:cache_dir] = "#{Chef::Config[:file_cache_path]}/omnibus_updater"
default[:omnibus_updater][:cache_omnibus_installer] = false
default[:omnibus_updater][:remove_chef_system_gem] = false
default[:omnibus_updater][:prerelease] = false
default[:omnibus_updater][:disabled] = false
default[:omnibus_updater][:upgrade_behavior] = 'exec'
default[:omnibus_updater][:upgrade_notification] = :immediately
default[:omnibus_updater][:exec_command] = 'chef-client'
# restore the 'classic' behavior with:
# default[:omnibus_updater][:upgrade_behavior] = 'kill'
# default[:omnibus_updater][:upgrade_notification] = :delayed
default[:omnibus_updater][:always_download] = false
default[:omnibus_updater][:prevent_downgrade] = false
default[:omnibus_updater][:restart_chef_service] = false
default[:omnibus_updater][:checksum] = nil
