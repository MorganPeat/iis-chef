#
# Cookbook:: morgan1
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Ensure IIS is installed
dsc_resource "install iis" do
    resource :windowsfeature
    property :name, 'Web-Server'
    property :ensure, 'Present'
end
