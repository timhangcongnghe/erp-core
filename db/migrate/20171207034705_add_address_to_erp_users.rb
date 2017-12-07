class AddAddressToErpUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_users, :address, :string
  end
end
