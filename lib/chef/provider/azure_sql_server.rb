require 'chef/provisioning/azure_driver/azure_provider'

class Chef
  class Provider
    class AzureSqlServer < Chef::Provisioning::AzureDriver::AzureProvider
      action :create do
        restore = Azure.config.management_endpoint
		sql_server_exists = 0
        Azure.config.management_endpoint = azure_sql_management_endpoint
        Chef::Log.info("Creating AzureSqlServer: #{new_resource.name}")
        csql = Azure::SqlDatabaseManagementService.new
        Chef::Log.info("#{new_resource.options.inspect}")
		# hack!
		csql.list_servers.each do | m |
           name = m.name
	       csql.list_sql_server_firewall_rules("#{name}").each do | n |
		      if n[:rule] == new_resource.name
			     Azure.config.management_endpoint = restore
			     puts "SQL server already exists in this subscription."
				 sql_server_exists = 1
			  end
		   end
		end
		
		if sql_server_exists == 0
			properties = csql.create_server("#{new_resource.options[:login]}", \
											"#{new_resource.options[:password]}", \
											"#{new_resource.options[:location]}")
			server = properties.name
			
			# Create a dummy range for our hack rule
			range = {
			   :start_ip_address => "192.168.1.2",
			   :end_ip_address => "192.168.1.2"
			}
			# Add the hack rule
			csql.set_sql_server_firewall_rule(server, new_resource.name, range)

			new_resource.options[:firewall_rules].each do | rule |
			  rule_name = URI::encode(rule[:name])
			  range = {
				:start_ip_address => rule[:start_ip_address],
				:end_ip_address => rule[:end_ip_address]
			  }
			  csql.set_sql_server_firewall_rule(server, rule_name, range)
			end

			Chef::Log.info("Properties of #{new_resource.name}: #{properties.inspect}")
		end
        Azure.config.management_endpoint = restore
      end

      action :destroy do
        restore = Azure.config.management_endpoint
        Azure.config.management_endpoint = azure_sql_management_endpoint
        Chef::Log.info("Destroying AzureSQLServer: #{new_resource.name}")
        csql = Azure::SqlDatabaseManagementService.new
		csql.delete_server(new_resource.name)
		Azure.config.management_endpoint = restore
      end
    end
  end
end