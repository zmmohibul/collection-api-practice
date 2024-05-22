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

  def as_json(_options={})
    {
      id: self.id,
      name: self.name,
      item_fields: self.item_field_values.map(&:as_json),
      created_at: self.created_at
    }
  end

  private
  def validate_item_field_values
    self.item_field_values.each do |item_field_value|
      item_field_description = self.collection.item_field_descriptions.find {
        |field_description| field_description.id == item_field_value.item_field_description_id
      }
      unless item_field_description
        self.errors.add(:item_field_values,
                        invalid_item_field_description_message(item_field_value.item_field_description_id, collection_id))
      end
    end
  end

  def missing_item_field_value_check
    self.collection.item_field_descriptions.each do |item_field_description|
      ifv = self.item_field_values.find { |fv| fv[:item_field_description_id] == item_field_description.id }
      unless ifv
        self.errors.add :item_field_values, missing_item_field_value_message(item_field_description.name)
      end
    end
  end

  def invalid_item_field_description_message(item_field_description_id, collection_id)
    "Item field description id: #{item_field_description_id} for collection id: #{collection_id} does not exist"
  end

  def missing_item_field_value_message(field_name)
    "Item field #{field_name} is missing"
  end
end
