class Api::CollectionsController < ApplicationController
  before_action :authorize, only: [:create, :destroy]

  rescue_from ArgumentError, with: :argument_error

  def index
    render json: Collection.all
  end

  def create
    if user_has_collection_with_same_name
      return entity_with_same_name_exist_error "collection"
    end

    collection = instantiate_collection_from_params
    add_item_field_descriptions_to_collection collection

    return render json: collection_errors(collection), status: 422 unless collection.save

    render json: collection, status: 201
  end

  def destroy
    collection = Collection.find(params[:id])
    return unauthorized unless resource_belongs_to_current_user collection
    collection.destroy
    render status: :no_content
  end

  private
  def collection_errors(collection)
    errors = {}.merge!(collection.errors)

    errors[:item_field_descriptions] = {} if collection.errors[:item_field_descriptions]
    collection.item_field_descriptions.each do |ifd|
      if ifd.errors.any?
        errors[:item_field_descriptions].merge!(ifd.errors.messages)
      end
    end

    errors if errors.any?
  end
  def collection_params
    params.permit(:name,
                  :description,
                  :category_id,
                  item_field_descriptions: [ :name, :data_type ])
  end

  def item_field_descriptions
    params.require(:item_field_descriptions).permit(:name, :data_type)
  end

  def user_has_collection_with_same_name
    Collection.where(name: params[:name], user_id: @current_user.id).exists?
  end

  def instantiate_collection_from_params
    Collection.new(name: collection_params[:name],
                   description: collection_params[:description],
                   category_id: collection_params[:category_id],
                   user: @current_user)
  end

  def add_item_field_descriptions_to_collection(col)
    if collection_params[:item_field_descriptions].present?
      collection_params[:item_field_descriptions].each do |field_description|
        ifd = ItemFieldDescription.new(name: field_description[:name], data_type: field_description[:data_type])
        col.item_field_descriptions << ifd
      end
    end
  end

  def argument_error(e)
    render json: { "invalid_value": [e] }, status: :unprocessable_entity
  end
end

