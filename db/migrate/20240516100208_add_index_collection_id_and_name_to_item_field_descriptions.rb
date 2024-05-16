class AddIndexCollectionIdAndNameToItemFieldDescriptions < ActiveRecord::Migration[7.1]
  def change
    add_index :item_field_descriptions, [:collection_id, :name], :unique => true
  end
end
