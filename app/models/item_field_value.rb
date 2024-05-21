class ItemFieldValue < ApplicationRecord
  belongs_to :item_field_description
  belongs_to :item

  validates :item_field_description, presence: true

  validates :item_id, numericality: { only_integer: true, minimum: 0, allow_nil: true }
  validates :date_value_before_type_cast,
            format: { with: /\A\d+-\d{2}-\d{2}\z/, message: "Invalid date format." }, allow_nil: true

  validates :int_value, presence: {
    message: ->(object, data) do
      "#{object.item_field_description.name} must be present"
    end
  }, if: :value_type_int?

  validates :string_value, presence: {
    message: ->(object, data) do
      "#{object.item_field_description.name} must be present"
    end
  }, if: :value_type_string?

  validates :text_value, presence: {
    message: ->(object, data) do
      "#{object.item_field_description.name} must be present"
    end
  }, if: :value_type_text?

  validates :boolean_value, presence: {
    message: ->(object, data) do
      "#{object.item_field_description.name} must be present"
    end
  }, if: :value_type_boolean?

  validates :date_value, presence: {
    message: ->(object, data) do
      "#{object.item_field_description.name} must be present"
    end
  }, if: :value_type_date?

  private
  def value_type_int?
    self.item_field_description.int_type?
  end

  def value_type_string?
    self.item_field_description.string_type?
  end

  def value_type_text?
    self.item_field_description.text_type?
  end

  def value_type_boolean?
    self.item_field_description.boolean_type?
  end

  def value_type_date?
    self.item_field_description.date_type?
  end
end
