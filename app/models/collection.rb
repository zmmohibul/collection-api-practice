class Collection < ApplicationRecord
  has_many :item_field_descriptions, dependent: :destroy
  has_many :items, dependent: :destroy
  belongs_to :category
  belongs_to :user

  validates :name, :description, presence: true
  validates_uniqueness_of :name, scope: :user_id, message: "can't have multiple collection with same name."
  def as_json(_options = {})
    {
      :id => self.id,
      :name => self.name,
      :description => self.description,
      :category => self.category(&:as_json),
      :itemFieldDescriptions => self.item_field_descriptions.map(&:as_json),
      :user => self.user(&:as_json),
      :created_at => self.created_at
    }
  end
end
