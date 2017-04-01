class AddColumnsToErpUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_users, :name, :string
    add_column :erp_users, :avatar, :string
    add_column :erp_users, :timezone, :string
    add_column :erp_users, :active, :boolean, default: false
    add_reference :erp_users, :creator, index: true, references: :erp_users
  end
end
