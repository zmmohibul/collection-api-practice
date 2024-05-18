class ItemFieldDescription < ApplicationRecord
  belongs_to :collection
  has_many :item_field_values, dependent: :destroy

  validates :name, :data_type, presence: true
  validates_uniqueness_of :name, scope: :collection_id, message: "can't have multiple fields with same name."
  enum data_type: { int_type: "int", string_type: "string", text_type: "text", boolean_type: "boolean", date_type: "date" }

  def as_json(_options={})
    {
      :id => self.id,
      :name => self.name,
      :dataType => ItemFieldDescription.data_types[self.data_type],
    }
  end
end
