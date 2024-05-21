class ItemFieldValue < ApplicationRecord
  belongs_to :item_field_description
  belongs_to :item

  validates :item_field_description, presence: true

  validates :item_id, numericality: { only_integer: true, minimum: 0, allow_nil: true }
  validates :date_value_before_type_cast,
            format: { with: /\A\d+-\d{2}-\d{2}\z/ }, allow_nil: true
end
