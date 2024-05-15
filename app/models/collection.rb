class Collection < ApplicationRecord
  has_many :item_field_descriptions, dependent: :destroy

  validates :name, :description, presence: true
end
