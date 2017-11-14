class AddUserGroupIdToErpUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_users, :user_group, index: true, references: :erp_user_groups
  end
end
