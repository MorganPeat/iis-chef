#
# Cookbook:: morgan1
# Recipe:: web
#
# Copyright:: 2018, The Authors, All Rights Reserved.

powershell_package_source 'Nuget' do
    action :register
    provider_name 'NuGet'
    url 'https://www.nuget.org/api/v2/'
    trusted true

end

powershell_package 'Install xWebAdministration' do
    action :install
    package_name 'xWebAdministration'
    version '2.3.0.0'
end


dsc_resource "stop default" do
    resource :xWebsite
    property :name, 'Default Web Site'
    property :ensure, 'Present'
    property :state, 'Stopped'
    property :physicalpath, 'C:\inetpub\wwwroot'    
end