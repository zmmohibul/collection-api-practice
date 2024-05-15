class CreateItemFieldDescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :item_field_descriptions do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
