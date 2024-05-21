class Api::CollectionsController < ApplicationController
  before_action :authorize, only: [:create, :destroy, :update]

  def index
    render json: Collection.all
  end

  def create
    collection = create_collection
    collection.save
    render_response collection, 201
  end

  def update
    collection = Collection.find(params[:id])
    return forbidden unless resource_belongs_to_current_user collection
    update_collection collection
    render_response collection, 200
  end

  def destroy
    collection = Collection.find(params[:id])
    return forbidden unless resource_belongs_to_current_user collection
    collection.destroy
    render status: :no_content
  end

  private
  def create_collection
    collection = Collection.new(collection_params)
    collection.user = @current_user
    create_item_field_descriptions collection
    collection
  end

  def create_item_field_descriptions(collection)
    item_field_descriptions_params.each do |field|
      create_item_field_description field, collection
    end
  end

  def create_item_field_description(field_description, collection)
    item_field = ItemFieldDescription.new(name: field_description[:name],
                                          data_type: field_description[:data_type])
    collection.item_field_descriptions << item_field
  end

  def update_collection(collection)
    if collection.update(collection_params)
      update_item_field_descriptions collection
      collection.save
    end
  end

  def update_item_field_descriptions(collection)
    item_field_descriptions_params.each do |field|
      if field[:id]
        update_item_field_description field[:id], field, collection
      else
        create_item_field_description field, collection
      end
    end
  end

  def update_item_field_description(id, field_description, collection)
    item_field_in_db = ItemFieldDescription.find(id)
    item_field_in_db.name = field_description[:name] if field_description[:name]
    collection.item_field_descriptions << item_field_in_db
  end

  def render_response(collection, status)
    errors = collection_errors collection
    return render json: errors, status: 422 if errors
    render json: collection, status: status
  end

  def collection_errors(collection)
    errors = create_collection_errors collection
    add_item_field_description_errors errors, collection
    errors if errors.any?
  end

  def create_collection_errors(collection)
    errors = {}
    errors.merge!(collection.errors) if collection.errors.any?
    errors
  end

  def add_item_field_description_errors(errors, collection)
    ifd_errors = item_field_descriptions_errors collection
    errors[:item_field_descriptions] = ifd_errors if ifd_errors.any?
  end


  def item_field_descriptions_errors(collection)
    errors = {}
    collection.item_field_descriptions.each do |ifd|
      errors.merge!(ifd.errors.messages) if ifd.errors.any?
    end
    errors
  end

  def collection_params
    params.permit(:name, :description, :category_id)
  end

  def item_field_descriptions_params
    params.fetch(:item_field_descriptions, [])
  end

  def user_has_collection_with_same_name
    Collection.where(name: params[:name], user_id: @current_user.id).exists?
  end
end

