require 'chef/provisioning/azure_driver/azure_provider'

class Chef
  class Provider
    class AzureQueue < Chef::Provisioning::AzureDriver::AzureProvider
      action :create do
		restore_namespace = Azure.config.sb_namespace
		restore_key = Azure.config.sb_access_key
		Azure.config.sb_namespace = new_resource.options[:sb_namespace]
		Azure.config.sb_access_key =  new_resource.options[:access_key]		
        Chef::Log.info("Creating AzureQueue: #{new_resource.name} in AzureServiceBus ${new_resource.options[:sb_namespace]}")		
        sbs = Azure::ServiceBusService.new
        sbs.create_queue(new_resource.name)		
		Azure.config.sb_namespace = restore_namespace
		Azure.config.sb_access_key = restore_key
      end

      action :destroy do
		restore_namespace = Azure.config.sb_namespace
		restore_key = Azure.config.sb_access_key
		Azure.config.sb_namespace = new_resource.options[:sb_namespace]
		Azure.config.sb_access_key =  new_resource.options[:access_key]	
        Chef::Log.info("Destroying AzureQueue: #{new_resource.name} in AzureServiceBus ${new_resource.options[:sb_namespace]}")
        sbs = Azure::ServiceBusService.new
        sbs.delete_queue(new_resource.name)
		Azure.config.sb_namespace = restore_namespace
		Azure.config.sb_access_key = restore_key
      end
    end
  end
end
