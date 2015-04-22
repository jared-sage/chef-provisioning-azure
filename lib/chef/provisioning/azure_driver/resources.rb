resources = %w(storage_account cloud_service sql_server service_bus queue)

resources.each do |r|
  Chef::Log.debug("Loading resource: #{r}")
  require "chef/resource/azure_#{r}"
  require "chef/provider/azure_#{r}"
end
