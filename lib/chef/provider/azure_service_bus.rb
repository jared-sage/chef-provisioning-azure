require 'chef/provisioning/azure_driver/azure_provider'

class Chef
  class Provider
    class AzureServiceBus < Chef::Provisioning::AzureDriver::AzureProvider
      action :create do
        Chef::Log.info("Creating AzureServiceBus: #{new_resource.name}")
		cmd = "azure sb namespace create #{new_resource.name} #{new_resource.options[:location]}"		
		bash = %x[ #{cmd} ]
      end

      action :destroy do
        Chef::Log.info("Destroying AzureServiceBus: #{new_resource.name}")
        cmd = "azure sb namespace delete #{new_resource.name}"		
		bash = %x[ #{cmd} ]
      end
    end
  end
end
