#
# Cookbook Name:: omnibus_updater
# Recipe:: downloader
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

# NOTE: This recipe is here for others that just want the
# package, not the actual installation (lxc for example)

include_recipe 'omnibus_updater::omnitruck_url'

if(remote_path = node[:omnibus_updater][:full_url])

  directory node[:omnibus_updater][:cache_dir] do
    recursive true
  end

  remote_file "omnibus_remote[#{File.basename(remote_path)}]" do
    path File.join(node[:omnibus_updater][:cache_dir], File.basename(remote_path))
    source remote_path
    backup false
    checksum node[:omnibus_updater][:checksum] if node[:omnibus_updater][:checksum]
    action :create_if_missing
    only_if { node[:omnibus_updater][:update_needed] }
  end
else
  Chef::Log.warn 'Failed to retrieve omnibus download URL'
end

include_recipe 'omnibus_updater::old_package_cleaner'
