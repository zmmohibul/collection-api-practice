class AddItemFieldDescriptionToItemFieldValues < ActiveRecord::Migration[7.1]
  def change
    add_reference :item_field_values, :item_field_description, null: false, foreign_key: true
  end
end
