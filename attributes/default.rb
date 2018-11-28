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
    'web-server',
    'web-common-http',
    'web-http-errors',
    'web-health',
    'web-http-logging',
    'web-custom-logging',
    'web-log-libraries',
    'web-http-tracing',
    'web-performance',
    'web-stat-compression',
    'web-dyn-compression',
    'web-security',
    'web-filtering',
    'web-basic-auth',
    'web-certprovider',
    'web-url-auth',
    'web-net-ext45',
    'web-asp-net45',
    'web-websockets',
    'web-mgmt-tools'
    # TODO: Net-Framework-Core Net-Framework-45-Core??
]

# Powershell packges required during Chef bootstrapping
default['iis']['powershell-packages'] = {
    'xWebAdministration'            => '2.3.0.0',
    'xPSDesiredStateConfiguration'  => '8.4.0.0',
    'NetworkingDsc'                 => '6.1.0.0' }


# Name of the IIS website
default['iis']['name'] = ''
# URI where the artifact should be downloaded from (zip file, extracted to site physical path)
default['iis']['artifact_uri'] = '' 
# Path where artifact should be extracted to; physical path for IIS web site
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