#
# Cookbook:: mogran1
# Recipe:: add_iis_application
#
# Copyright:: 2018, NWM, All Rights Reserved.

# Grant IIS (w3wp.exe) rights to read the binaries
directory node['iis']['physicalPath'] do
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

  def to_psobject
    bindings = []
    @bindings.each do |b|
      bindings.push("(new-ciminstance -classname MSFT_xWebBindingInformation -Namespace root/microsoft/Windows/DesiredStateConfiguration -Property @{Protocol='#{b[:protocol]}';IPAddress='#{b[:ip]}';Port=#{b[:port]}} -ClientOnly)")
    end
    "[ciminstance[]](#{bindings.join(',')})"
  end
end

dsc_resource 'Create App Pool' do
  resource :xWebAppPool
  property :name, node['iis']['name']
  property :state, node['iis']['pool-state']
  property :autoStart, true
  property :enable32BitAppOnWin64, node['iis']['32-bit-pool']
  property :managedPipelineMode, 'Integrated'
  property :managedRuntimeVersion, 'v4.0'
end

dsc_resource 'Create Website' do
  resource :xWebsite
  property :name, node['iis']['name']
  property :physicalPath, node['iis']['physicalPath']
  property :state, node['iis']['site-state']
  property :bindingInfo, WebsiteBindings.new(node['iis']['bindings'])
  property :applicationPool, node['iis']['name']
end

# Open a port for each IIS binding
node['iis']['bindings'].each do |binding|
  dsc_resource "Open Firewall (#{binding[:port]})" do
    resource :Firewall
    property :name, "#{node['iis']['name']}-#{binding[:port]}"
    property :displayName, "#{node['iis']['name']} (TCP #{binding[:port]} in)"
    property :action, 'Allow'
    property :direction, 'Inbound'
    property :localPort, [binding[:port].to_s]
    property :protocol, 'TCP'
    property :profile, ['Any']
    property :enabled, 'True'
  end
end
