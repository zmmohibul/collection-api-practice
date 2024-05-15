class Category < ApplicationRecord
  has_many :collections, dependent: :destroy

  def as_json(_options = {})
    {
      id: id,
      name: name
    }
  end
end
