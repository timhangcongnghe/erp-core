class AddCacheSearchToErpUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_users, :cache_search, :text
  end
end
