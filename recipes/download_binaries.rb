#
# Cookbook:: morgan1
# Recipe:: download_binaries
#
# Copyright:: 2018, NWM, All Rights Reserved.

dsc_resource 'Download binaries' do
  resource :xRemoteFile
  property :Uri, node['iis']['artifact_uri']
  property :DestinationPath, "#{Chef::Config[:file_cache_path]}\\artifact.zip"
end

dsc_resource 'Create target folder' do
  resource :File
  property :Type, 'Directory'
  property :DestinationPath, node['iis']['physicalPath']
end

dsc_resource 'Extract binaries' do
  resource :archive
  property :ensure, 'Present'
  property :path, "#{Chef::Config[:file_cache_path]}\\artifact.zip"
  property :destination, node['iis']['physicalPath']
end
