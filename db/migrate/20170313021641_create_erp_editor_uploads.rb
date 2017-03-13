class CreateErpEditorUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_editor_uploads do |t|
      t.string :image_url

      t.timestamps
    end
  end
end
