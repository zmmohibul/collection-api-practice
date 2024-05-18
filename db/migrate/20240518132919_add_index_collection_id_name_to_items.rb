class AddIndexCollectionIdNameToItems < ActiveRecord::Migration[7.1]
  def change
    add_index :items, [:collection_id, :name], :unique => true
  end
end
