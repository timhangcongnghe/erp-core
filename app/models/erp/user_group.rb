module Erp
  class UserGroup < ApplicationRecord
    validates :name, presence: true

    has_many :users, class_name: 'Erp::User'
    belongs_to :creator, class_name: 'Erp::User'

    def get_name
      name
    end

    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      if params['filters'].present?
        params['filters'].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            or_conds << "#{cond[1]['name']} = '#{cond[1]['value']}'"
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end
      if params['keywords'].present?
        params['keywords'].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]['name']}) LIKE '%#{cond[1]['value'].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
      query = query.joins(:creator)
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        query = query.order(order)
      end
      return query
    end

    def self.dataselect(keyword='')
      query = self.all
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      query = query.limit(10).map{|user_group| {value: user_group.id, text: user_group.get_name}}
    end
 
    def activate
			update_columns(active: true)
		end

    def deactivate
			update_columns(active: false)
		end

    def update_permissions(permissions_params)
      self.update_column(:permissions, permissions_params.to_json)
    end

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

    def self.permissions_array
      arr = {
        products: {
          products: {
            products: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            categories: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            brands: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            accessories: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            erp_connect: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        },
        properties: {
          properties: {
            property_groups: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            properties: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            properties_values: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        },
        menus: {
          menus: {
            menus: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        },
        orders: {
          orders: {
            orders: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        },
        articles: {
          articles: {
            articles: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            categories: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        },
        users: {
          users: {
            users: {
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            },
            user_groups:{
              index: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              create: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              update: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              delete: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        },
        system: {
          system: {
            system: {
              settings: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              backup: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]},
              restore: {value: 'no', options: [{value: 'yes', text: 'Có'}, {value: 'no', text: 'Không'}]}
            }
          }
        }
      }
      arr
    end
  end
end