module Erp
  class UserGroup < ApplicationRecord
    validates :name, presence: true
    has_many :users
    belongs_to :creator, class_name: "Erp::User"

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      return query
    end

    def self.search(params)
      query = self.order("created_at DESC")
      query = self.filter(query, params)

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|user_group| {value: user_group.id, text: user_group.name} }
    end
    
    # activate
    def activate
			update_columns(active: true)
		end
    
    # deactivate
    def deactivate
			update_columns(active: false)
		end

    # update permissions
    def update_permissions(permissions_params)
      self.update_column(:permissions, permissions_params.to_json)
    end

    # get permissions
    def get_permissions
      permissions = UserGroup.permissions_array
      saved_permissions = self.permissions.present? ? JSON.parse(self.permissions) : {}

      permissions.each do |h_group|
        h_group[1].each do |h_engine|
          h_engine[1].each do |h_controller|
            h_controller[1].each do |h_permission|
              if saved_permissions[h_group[0].to_s].present? and
                saved_permissions[h_group[0].to_s][h_engine[0].to_s].present? and
                saved_permissions[h_group[0].to_s][h_engine[0].to_s][h_controller[0].to_s].present?
                saved_permissions[h_group[0].to_s][h_engine[0].to_s][h_controller[0].to_s][h_permission[0].to_s].present? and
                  permissions[h_group[0]][h_engine[0]][h_controller[0]][h_permission[0]][:value] = saved_permissions[h_group[0].to_s][h_engine[0].to_s][h_controller[0].to_s][h_permission[0].to_s]['value']
              end
            end
          end
        end
      end

      permissions
    end

    # Permission array
    def self.permissions_array
      arr = {
        # Inventory
        inventory: {
          order_stock_checks: {
            schecks: {
              check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              approve_order: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
          qdeliveries: {
            deliveries: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              sales_orders: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              purchase_orders: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
          stock_transfers: {
            transfers: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              check_transfer: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
          products: {
            warehouse_checks: {
              state_check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              stock_check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              damage_check: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            products: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            warehouses: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            states: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            categories: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            properties: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            manufacturers: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
        },
        sales: {
          sales: {
            orders: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
          gift_givens: {
            gift_givens: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
          consignments: {
            consignments: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              return: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
          prices: {
            customer_prices: {
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update_general: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
        },
        purchase: {
          purchase: {
            orders: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
          prices: {
            supplier_prices: {
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update_general: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
          products: {
            stock_import: {
              view: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            areas: {
              side: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              central: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            }
          },
        },
        accounting: {
          payments: {
            payment_records: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            accounts: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            payment_types: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
          chase: {
            chase: {
              sales: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              purchase: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              return: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            customer_commision: {
              customer: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              supplier: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            commision: {
              customer: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              employee: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
        },
        contacts: {
          contacts: {
            contacts: {
              index: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
        },
        options: {
          users: {
            users: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            user_groups: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
          targets: {
            targets: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            company_targets: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
          periods: {
            periods: {
              index: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              create: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              update: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
        },
        report: {
          report: {
            inventory: {
              matrix: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              delivery: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              delivery_detail: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              category_diameter: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              product: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              central_area: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              custom_area: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              outside_product: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              warehouse: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            sales: {
              sales: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              sales_details: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              returning: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              new_patient: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
            accounting: {
              pay_receive_details: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              payment_types: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              sales: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              revenue_report: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              accounts: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              customer_liabilities: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              supplier_liabilities: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              liabilities_arising: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ]
              },
              period_liabilities: {
                value: 'yes',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
        },
        system: {
          system: {
            system: {
              settings: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              backup: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
              restore: {
                value: 'no',
                options: [
                  {value: 'yes', text: 'Có'},
                  {value: 'no', text: 'Không'},
                ],
              },
            },
          },
        },
      }

      arr
    end
  end
end
