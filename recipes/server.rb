if(node['chef-server'] && !node['chef-server'][:package_file].to_s.include?(node[:omnibus_updater][:server][:version].to_s))
  path = Dir.glob(File.join(Chef::Config[:file_cache_path], '*chef-server*.*')).detect do |path|
    path.include?(node[:omnibus_updater][:server][:version].to_s)
  end
  if(path)
    node.set['chef-server'][:package_file] = path
  else
    Chef::Log.warn 'Chef Server: Package file not found. Starting upgrade process!'
    Chef::Log.warn 'Chef Server: Server will be down until upgrade completes!'
    node.set['chef-server'].delete(:package_file)
  end
end

node.set['chef-server'][:version] = node[:omnibus_updater][:server][:version]
node.set['chef-server'][:prereleases] = node[:omnibus_updater][:server][:prereleases]
node.set['chef-server'][:nightlies] = node[:omnibus_updater][:server][:nightlies]

execute 'Stop Chef Server for upgrade' do
  command 'chef-server-ctl stop'
  only_if{ node['chef-server'][:package_file].nil? }
  notifies :run, 'execute[Reconfigure Chef Server after upgrade]'
end

include_recipe 'chef-server'

execute 'Reconfigure Chef Server after upgrade' do
  command 'chef-server-ctl reconfigure'
  action :nothing
end

path = Dir.glob(File.join(Chef::Config[:file_cache_path], '*chef-server*.*')).detect do |path|
  path.include?(node[:omnibus_updater][:server][:version].to_s)
end

# TODO: Auto-checksum file pulled
node.set['chef-server'][:package_file] = path if path
