class Item < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :item_field_values, dependent: :destroy

  validates :name, :collection_id, presence: true
  validates :collection, presence: true

  before_validation do
    validate_item_field_values
    missing_item_field_value_check
  end

  private
  def validate_item_field_values
    self.item_field_values.each do |item_field_value|
      item_field_description = self.collection.item_field_descriptions.find {
        |field_description| field_description.id == item_field_value.item_field_description_id
      }
      unless item_field_description
        self.errors.add(:item_field_value,
                        "Item field description id: #{item_field_value.item_field_description_id} for collection id: #{collection.id} not found")
      end
    end
  end

  def missing_item_field_value_check
    self.collection.item_field_descriptions.each do |item_field_description|
      ifv = self.item_field_values.find { |fv| fv[:item_field_description_id] == item_field_description.id }
      unless ifv
        self.errors.add :item_field_value, "#{item_field_description.name} is missing"
      end
    end
  end
end
