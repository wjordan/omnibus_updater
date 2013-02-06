include_recipe 'omnibus_updater::set_remote_path'
node.default[:omnibus_updater][:remove_old_packages] = true

remote_file "chef omnibus_package[#{File.basename(node[:omnibus_updater][:full_uri])}]" do
  path File.join(node[:omnibus_updater][:cache_dir], File.basename(node[:omnibus_updater][:full_uri]))
  source node[:omnibus_updater][:full_uri]
  backup false
  not_if do
    File.exists?(
      File.join(node[:omnibus_updater][:cache_dir], File.basename(node[:omnibus_updater][:full_uri]))
    ) || (
      Chef::VERSION.to_s.scan(/\d+\.\d+\.\d+/) == node[:omnibus_updater][:full_version].scan(/\d+\.\d+\.\d+/) && OmnibusChecker.is_omnibus?
    )
  end
  if(node[:omnibus_updater][:immediate_kill_on_upgrade])
    notifies :run, "execute[chef omnibus_install[#{node[:omnibus_updater][:full_version]}]]", :immediate
  else
    notifies :create, 'ruby_block[Omnibus Chef install notifier]', :delayed
  end
end

ruby_block 'Omnibus Chef install notifier' do
  block do
    true
  end
  action :nothing
  notifies :run, "execute[chef omnibus_install[#{node[:omnibus_updater][:full_version]}]]", :delayed
end

ruby_block 'Omnibus Chef install killer' do
  block do
    raise Exception.new("Omnibus Chef installation updated. Forcing full chef halt!")
  end
  action :nothing
end
