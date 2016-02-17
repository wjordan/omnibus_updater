# This helper recipe sets node[:omnibus_updater][:full_url] and
# node[:omnibus_updater][:update_needed] attributes after querying the
# Omnitruck API.

if(node[:omnibus_updater][:direct_url])
  remote_path = node[:omnibus_updater][:direct_url]
else
  version = node[:omnibus_updater][:version] || ''
  remote_path = OmnibusTrucker.url(
    OmnibusTrucker.build_url(node,
      :version => node[:omnibus_updater][:force_latest] ? nil : version.sub(/\-.+$/, ''),
      :prerelease => node[:omnibus_updater][:preview]
    ), node
  )
end

node.set[:omnibus_updater][:full_url] = remote_path

version = node[:omnibus_updater][:full_url].scan(%r{chef[_-](\d+\.\d+.\d+)}).flatten.first

node.set[:omnibus_updater][:update_needed] =
  if(node[:omnibus_updater][:always_download])
    # warn if there may be unexpected behavior
    node[:omnibus_updater][:prevent_downgrade] &&
      Chef::Log.warn("omnibus_updater: prevent_downgrade is ignored when always_download is true")
    Chef::Log.debug "Omnibus Updater remote path: #{remote_path}"
    true
  elsif(node[:omnibus_updater][:prevent_downgrade])
    # Return true if the found/specified version is newer
    Gem::Version.new(version.to_s.sub(/\-.+$/, '')) > Gem::Version.new(Chef::VERSION)
  else
    # default is to install if the versions don't match
    Chef::VERSION != version.to_s.sub(/\-.+$/, '')
  end
