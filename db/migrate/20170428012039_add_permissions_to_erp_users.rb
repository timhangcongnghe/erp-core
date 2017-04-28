class AddPermissionsToErpUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_users, :permissions, :text
  end
end
