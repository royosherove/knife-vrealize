require 'chef/knife'

require 'chef/knife/cloud/list_resource_command'
require 'chef/knife/cloud/vra_service'
require 'chef/knife/cloud/vra_service_helpers'
require 'chef/knife/cloud/vra_service_options'

class Chef
  class Knife
    class Cloud
      class VraCatalogList < ResourceListCommand
        include VraServiceHelpers
        include VraServiceOptions

        banner 'knife vra catalog list'

        option :entitled,
          long:        '--entitled-only',
          description: 'only list entitled vRA catalog entries',
          boolean:     true,
          default:     false

        def run
          validate_required_config!

          if get_config_value(:entitled)
            items = vra_client.catalog.entitled_items
            items.map! { |x| x['catalogItem'] }
          else
            items = vra_client.catalog.all_items
          end

          if items.empty?
            ui.warn('There are no catalog items available.')
            exit 1
          end

          catalog_list = [
            ui.color('Catalog ID', :bold),
            ui.color('Name', :bold),
            ui.color('Description', :bold),
            ui.color('Status', :bold)
          ]

          items.each do |item|
            catalog_list << item['id']
            catalog_list << item['name']
            catalog_list << item['description']
            catalog_list << item['statusName']
          end

          puts ui.list(catalog_list, :uneven_columns_across, 4)
        end
      end
    end
  end
end
