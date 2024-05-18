class AddItemToItemFieldValues < ActiveRecord::Migration[7.1]
  def change
    add_reference :item_field_values, :item, null: false, foreign_key: true
  end
end
