class AddActiveToErpUserGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_user_groups, :active, :boolean, default: true
  end
end
