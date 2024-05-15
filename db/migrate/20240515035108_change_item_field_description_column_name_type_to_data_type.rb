class ChangeItemFieldDescriptionColumnNameTypeToDataType < ActiveRecord::Migration[7.1]
  def change
    change_table :item_field_descriptions do |t|
      t.rename :type, :data_type
    end
  end
end
