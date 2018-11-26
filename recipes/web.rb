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

powershell_package 'Install xPSDesiredStateConfiguration' do
    action :install
    package_name 'xPSDesiredStateConfiguration'
    version '8.4.0.0'
end


dsc_resource "stop default" do
    resource :xWebsite
    property :name, 'Default Web Site'
    property :ensure, 'Present'
    property :state, 'Stopped'
end

dsc_resource "setup-dir-1" do
    resource :file
    property :ensure, 'Present'
    property :type, 'Directory'
    property :destinationpath, 'C:\Packages'
end

dsc_resource "setup-dir-2" do
    resource :file
    property :ensure, 'Present'
    property :type, 'Directory'
    property :destinationpath, 'C:\app'
end

dsc_resource "SchUseStrongCrypto" do
    resource :registry
    property :ensure, 'Present'
    property :key, 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
    property :valuename, 'SchUseStrongCrypto'
    property :valuetype, 'Dword'
    property :valuedata, ['1']
end

dsc_resource "SchUseStrongCrypto64" do
    resource :registry
    property :ensure, 'Present'
    property :key, 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
    property :valuename, 'SchUseStrongCrypto'
    property :valuetype, 'Dword'
    property :valuedata, ['1']
end

dsc_resource "download web site" do
    resource :xremotefile
    property :ensure, 'Present'
    property :uri, 'http://github.com/MorganPeat/Pilot/releases/download/pilot-v1.0.13/Pilot.WebApi.zip'
    property :destinationpath, 'C:\packages\Pilot.WebApi.zip'
end

dsc_resource "unzip web site" do
    resource :archive
    property :ensure, 'Present'
    property :path, 'c:\packages\Pilot.WebApi.zip'
    property :destination, 'C:\app'
end


dsc_resource "app pool" do
    resource :xWebAppPool
    property :ensure, 'Present'
    property :name, 'Pilot.WebApi'
    property :state, 'Started'
    property :autoStart, true
    property :enable32BitAppOnWin64, true
    property :managedPipelineMode, 'Integrated'
    property :managedRuntimeVersion, 'v4.0'
end

directory "c:\\app" do
    rights :read, 'IIS_IUSRS'
    recursive true
    action :create
end

# https://www.dotnetcatch.com/2016/05/11/dsc-in-chef-converting-ruby-hashes-to-powershell-types/
class WebsiteBindings 
    @bindings = [] 
    def initialize(bindings) 
      @bindings = bindings 
    end
       
    def to_psobject() 
      bindings = Array.new() 
      @bindings.each do |b| 
        bindings.push("(new-ciminstance -classname MSFT_xWebBindingInformation -Namespace root/microsoft/Windows/DesiredStateConfiguration -Property @{Protocol='#{b[:protocol]}';IPAddress='#{b[:ip]}';Port=#{b[:port]}} -ClientOnly)") 
      end
      "[ciminstance[]](#{bindings.join(',')})"
    end
  end

node.run_state['bindings'] = WebsiteBindings.new([ 
{ protocol: 'HTTP', ip: '*', port: 8080 }, 
{ protocol: 'HTTP', ip: '*', port: 8081 } ]) 


dsc_resource "create website" do
    resource :xWebsite
    property :ensure, 'Present'
    property :name, 'Pilot.WebApi'
    property :physicalPath, 'C:\app'
    property :state, 'Started'
    property :bindingInfo, node.run_state['bindings']
end

dsc_resource "create web application" do
    resource :xWebApplication
    property :ensure, 'Present'
    property :name, 'Pilot.WebApi'
    property :webSite, 'Pilot.WebApi'
    property :webAppPool, 'Pilot.WebApi'
    property :physicalPath, 'C:\app'
end
