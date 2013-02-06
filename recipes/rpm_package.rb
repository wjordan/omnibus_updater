include_recipe 'omnibus_updater::package'

execute "chef omnibus_install[#{node[:omnibus_updater][:full_version]}]" do
  command "rpm -Uvh #{File.join(node[:omnibus_updater][:cache_dir], File.basename(node[:omnibus_updater][:full_uri]))}"
  action :nothing
  if(node[:omnibus_updater][:immediate_kill_on_upgrade])
    notifies :create, "ruby_block[Omnibus Chef install killer]", :immediate
  end
end

