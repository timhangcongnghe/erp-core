class AddCreatorIdToErpUserGroups < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_user_groups, :creator, index: true, references: :erp_users
  end
end
