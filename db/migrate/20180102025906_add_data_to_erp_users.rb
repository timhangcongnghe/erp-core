class AddDataToErpUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_users, :data, :text
  end
end
