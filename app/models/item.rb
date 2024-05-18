class Item < ApplicationRecord
  belongs_to :collection
  has_many :item_field_values, dependent: :destroy
end
