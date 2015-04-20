require 'chef/provisioning/azure_driver/azure_resource'

class Chef
  class Resource
    class AzureServiceBus < Chef::Provisioning::AzureDriver::AzureResource
      resource_name 'azure_service_bus'
      actions :create, :destroy, :nothing
      default_action :create
      attribute :name, kind_of: String, name_attribute: true
      attribute :options
    end
  end
end
