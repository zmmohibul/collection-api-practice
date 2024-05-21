class Item < ApplicationRecord
  belongs_to :collection
  has_many :item_field_values, dependent: :destroy

  validates :name, :collection_id, presence: true
  validates :collection, presence: true
end
