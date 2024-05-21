class Api::ItemsController < ApplicationController
  before_action :authorize, only: [:create]
  def index
    render json: Item.includes(:item_field_values).all
  end

  def create
    collection = Collection.includes(:item_field_descriptions).find(item_params[:collection_id])
    return forbidden unless resource_belongs_to_current_user collection

    item = Item.new(name: item_params[:name], collection_id: collection.id, user_id: collection.user_id)
    collection.item_field_descriptions.each do |item_field_in_collection|
      field_value_in_param = field_values_params.find { |field_param| field_param[:item_field_description_id] == item_field_in_collection.id }
      unless field_value_in_param
        return render json: { "item_field_values": [ "Field #{item_field_in_collection.name} is missing" ] }, status: :unprocessable_entity
      end

      unless field_value_in_param[:value]
        return render json: { "item_field_values": [ "#{item_field_in_collection.name} can't be empty" ] }, status: :unprocessable_entity
      end

      item_field_value = item_field_value_for_data_type(ItemFieldDescription.data_types[item_field_in_collection.data_type],
                                                        field_value_in_param[:value])

      item_field_value.item_field_description = item_field_in_collection

      item.item_field_values << item_field_value
    end

    unless item.save
      return render json: item.errors, status: :unprocessable_entity
    end

    render json: item, status: :created
  end

  private
  def item_field_value_for_data_type(data_type, value)
    map = {
      ItemFieldDescription.data_types[:int_type] => ItemFieldValue.new(int_value: value),
      ItemFieldDescription.data_types[:date_type] => ItemFieldValue.new(date_value: value),
      ItemFieldDescription.data_types[:boolean_type] => ItemFieldValue.new(boolean_value: value),
      ItemFieldDescription.data_types[:string_type] => ItemFieldValue.new(string_value: value),
      ItemFieldDescription.data_types[:text_type] => ItemFieldValue.new(text_value: value)
    }
    map[data_type]
  end

  def item_params
    params.require(:item).permit(:name, :collection_id)
  end

  def field_values_params
    params.fetch(:item_field_values, [])
  end
end