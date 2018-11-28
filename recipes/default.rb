#
# Cookbook:: morgan1
# Recipe:: default
#
# Copyright:: 2018, NWM, All Rights Reserved.

override['iis']['name'] = 'Pilot.WebApi'
override['iis']['artifact_uri'] = 'http://github.com/MorganPeat/Pilot/releases/download/pilot-v1.0.15/Pilot.WebApi.zip'
override['iis']['physicalPath'] = 'C:\app'
override['iis']['bindings'] = [ { protocol: 'http', ip: '*', port: 8080 } ]
override['iis']['32-bit-pool'] = true


include_recipe 'morgan1::install_dependencies'
include_recipe 'morgan1::download_binaries'
include_recipe 'morgan1::add_iis_application'