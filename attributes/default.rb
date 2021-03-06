# frozen_string_literal: true

# Cookbook Name::morgan1
# Attributes::default.rb

###########################################################################################
# TODOs / Questions
#
# - Is the attributes file the best place to list features, DSC packages? Don't really want
#   to give callers the ability to modify / change it, it should be a bit more private to
#   the recipe.
# - Is there a way of forcing an attribute to be supplied? e.g. the artifacts url must be
#   supplied, there is no suitable default value, and the script should error with a suitable
#   message if a value is missing.
# - Where should we pick up Powershell DSC packages from? Artifactory? Can we get it to
#   act like a mirror, c.f. nuget?
###########################################################################################

# Windows features required for IIS applications to run
# TODO: CTOM-271 Determine correct Windows feature list for IIS deployment
# Use Get-WindowsFeature to see available features
default['iis']['windows-features'] = [
  'Web-Server',
  'Web-Common-Http',
  'Web-Http-Errors',
  'Web-Static-Content',
  'Web-Health',
  'Web-Http-logging',
  'Web-Log-Libraries',
  'Web-Performance',
  'Web-Stat-Compression',
  'Web-Dyn-Compression',
  'Web-Security',
  'Web-Filtering',
  'Web-Client-Auth',
  'Web-Digest-Auth',
  'Web-Cert-Auth',
  'Web-IP-Security',
  'Web-Url-Auth',
  'Web-Windows-Auth',
  'Web-Net-Ext45',
  'Web-Asp-Net45',
  'Web-WebSockets',
  'Web-Mgmt-Tools',
]

# Powershell packges required during Chef bootstrapping
default['iis']['powershell-packages'] = {
  'xWebAdministration'           => '2.3.0.0',
  'xPSDesiredStateConfiguration' => '8.4.0.0',
  'NetworkingDsc'                => '6.1.0.0',
  'GraniResource'                => '3.7.11.0',
}

# Name of the IIS website
default['iis']['name'] = ''
# URI where artifact is downloaded from (zip file, extracted to site physical path)
default['iis']['artifact_uri'] = ''
# Path where artifact is extracted to; physical path for IIS web site
default['iis']['physicalPath'] = 'C:\inetpub\wwwroot'
# Web site binding(s); an ingress firewall rule is created for each port
default['iis']['bindings'] = [
  { protocol: 'http', ip: '*', port: 80 },
  { protocol: 'https', ip: '*', port: 443 }
]
# Site is started or stopped on creation
default['iis']['site-state'] = 'Started'
# App pool is started or stopped on creation
default['iis']['pool-state'] = 'Started'
# 32- or 64-bit app pool process
default['iis']['32-bit-pool'] = false

# Values taken from https://support.microsoft.com/en-gb/help/4054531/microsoft-net-framework-4-7-2-web-installer-for-windows
default['dotnet']['uri'] = 'http://go.microsoft.com/fwlink/?LinkId=863262'
default['dotnet']['kb'] = 'KB4054590'
