class Api::ItemsController < ApplicationController
  before_action :authorize, only: [:create]
  def index
    render json: Item.includes(:item_field_values).all
  end

  def create
    @collection = Collection.includes(:item_field_descriptions).find(item_params[:collection_id])
    return forbidden unless resource_belongs_to_current_user @collection
    instantiate_new_item
    @item.save
    render_response
  end

  private
  def instantiate_new_item
    @item = Item.new(name: item_params[:name], collection: @collection, user: @collection.user)
    add_field_values_to_item
  end

  def add_field_values_to_item
    field_values_params.each do |param_field_value|
      item_field = ItemFieldDescription.find(param_field_value[:item_field_description_id])
      item_field_value = new_item_field_value(item_field_data_type(item_field), param_field_value[:value])
      item_field_value.item_field_description = item_field
      @item.item_field_values << item_field_value
    end
  end

  def new_item_field_value(data_type, field_value)
    item_field_value_for_data_type(data_type, field_value)
  end

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

  def item_field_data_type(item_field)
    ItemFieldDescription.data_types[item_field.data_type]
  end

  def item_params
    params.require(:item).permit(:name, :collection_id)
  end

  def field_values_params
    params.fetch(:item_field_values, [])
  end

  def render_response
    errors = item_errors @item
    if errors.any?
      return render json: item_errors(@item), status: :unprocessable_entity
    end
    render json: @item, status: :created
  end

  def item_errors(item)
    errors = {}
    errors.merge!(item.errors) if item.errors.any?
    ifv_error_list = error_list_of_models item.item_field_values
    if errors[:item_field_values]
      errors[:item_field_values].pop
      errors[:item_field_values].concat(ifv_error_list)
    else
      errors[:item_field_values] = ifv_error_list if ifv_error_list.any?
    end
    errors
  end
end