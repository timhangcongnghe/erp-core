class AddPermissionsToErpUserGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_user_groups, :permissions, :text
  end
end
