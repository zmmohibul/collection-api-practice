class AddCollectionToItemFieldDescriptions < ActiveRecord::Migration[7.1]
  def change
    add_reference :item_field_descriptions, :collection, null: false, foreign_key: true
  end
end
