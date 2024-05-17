class AddIndexUserIdAndCollectionToCollections < ActiveRecord::Migration[7.1]
  def change
    add_index :collections, [:user_id, :name], unique: true
  end
end
