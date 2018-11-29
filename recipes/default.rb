#
# Cookbook:: morgan1
# Recipe:: default
#
# Copyright:: 2018, NWM, All Rights Reserved.

node.default['iis']['name'] = 'Pilot.WebApi'
node.default['iis']['artifact_uri'] = 'http://github.com/MorganPeat/Pilot/releases/download/pilot-v1.0.15/Pilot.WebApi.zip'
node.default['iis']['physicalPath'] = 'C:\app'
node.default['iis']['bindings'] = [{ protocol: 'http', ip: '*', port: 8080 }]
node.default['iis']['32-bit-pool'] = true

include_recipe 'morgan1::setup_prerequisites'
include_recipe 'morgan1::download_binaries'
include_recipe 'morgan1::add_iis_application'
