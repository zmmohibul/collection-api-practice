class ItemFieldValue < ApplicationRecord
  belongs_to :item_field_description
  belongs_to :item
end
