#
# Cookbook:: morgan1
# Recipe:: setup_prerequisites
#
# Copyright:: 2018, NWM, All Rights Reserved.


# Ensure all necessary windows features are installed
node['iis']['windows-features'].each do |feature|
    dsc_resource "Install #{feature}" do
        resource :WindowsFeature
        property :Name, feature
    end
end


# Sets up the source of powershell packages
# TODO: Artifactory?
powershell_script 'Install-PackageProvider (NuGet)' do
    code 'Install-PackageProvider -Name NuGet -Force'
    not_if '(Get-PackageProvider -Name Nuget -ListAvailable -ErrorAction SilentlyContinue) -ne $null'
end
  
powershell_package_source 'Nuget' do
    action :register
    provider_name 'NuGet'
    url 'https://www.nuget.org/api/v2/'
    trusted true
end

node['iis']['powershell-packages'].each do |package, version|
    powershell_package "Install package #{package}" do
        action :install
        package_name package
        version version
    end
end



# Use strong crypto (>= TLS 1.1) by default
# https://docs.microsoft.com/en-us/dotnet/framework/network-programming/tls#configuring-security-via-the-windows-registry
[
    'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319',
    'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319'
].each do |key|
    dsc_resource 'SchUseStrongCrypto' do
        resource :registry
        property :key, key
        property :valuename, 'SchUseStrongCrypto'
        property :valuetype, 'Dword'
        property :valuedata, ['1']
    end
end

