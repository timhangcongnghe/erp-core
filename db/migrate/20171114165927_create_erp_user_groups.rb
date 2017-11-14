class CreateErpUserGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_user_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
