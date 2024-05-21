class ChangeColumnBooleanBooleanOfItemFieldValues < ActiveRecord::Migration[7.1]
  def change
    change_table :item_field_values do |t|
      t.rename :boolean_boolean, :boolean_value
    end
  end
end
