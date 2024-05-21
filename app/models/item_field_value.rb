class ItemFieldValue < ApplicationRecord
  belongs_to :item_field_description
  belongs_to :item

  validates :item_field_description, presence: true

  validates :item_id, numericality: { only_integer: true, minimum: 0, allow_nil: true }
  validates :date_value_before_type_cast,
            format: { with: /\A\d+-\d{2}-\d{2}\z/ }, allow_nil: true

  validates :string_value, presence: {
    message: ->(object, data) do
      "#{object.item_field_description.name} must be present"
    end
  }, if: :value_type_string?

  private
  def value_type_string?
    self.item_field_description.string_type?
  end
end
