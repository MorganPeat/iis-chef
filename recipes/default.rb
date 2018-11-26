#
# Cookbook:: morgan1
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Probably too many dependencies. TODO: trim down to required set
node.run_state['features'] = [
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
]
# Ensure IIS is installed
node.run_state['features'].each do |feature|
    dsc_resource "install #{feature}" do
        resource :windowsfeature
        property :name, feature
        property :ensure, 'Present'
    end
end

include_recipe 'morgan1::web'