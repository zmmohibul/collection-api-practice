class CreateItemFieldValues < ActiveRecord::Migration[7.1]
  def change
    create_table :item_field_values do |t|
      t.integer :int_value, null: true
      t.string :string_value, null: true
      t.text :text_value, null: true
      t.boolean :boolean_boolean, null: true
      t.datetime :date_value, null: true

      t.timestamps
    end
  end
end
