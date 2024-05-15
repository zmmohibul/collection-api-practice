class ItemFieldDescription < ApplicationRecord
  belongs_to :collection

  validates :name, :data_type, presence: true
  enum data_type: { int_type: "int", string_type: "string", text_type: "text", boolean_type: "boolean", date_type: "date" }

  def as_json(_options={})
    {
      :id => self.id,
      :name => self.name,
      :dataType => ItemFieldDescription.data_types[self.data_type],
    }
  end
end
