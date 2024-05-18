require 'rails_helper'

RSpec.describe "Collections", type: :request do
  let!(:user_mohib) { FactoryBot.create :user, username: "mohib", password: "mohibmoib" }
  let!(:user_musab) { FactoryBot.create :user, username: "musab", password: "musabmusab" }
  let!(:book_category) { FactoryBot.create(:category, name: "Book") }
  let!(:pet_category) { FactoryBot.create(:category, name: "Pet") }

  describe "Post /collections" do
    it 'creates a collection' do
      token = AuthenticationTokenService.encode(user_mohib)
      expect {
        post '/api/collections', params: {
          name: "Books",
          description: "Collection of books",
          category_id: book_category.id,
          "item_field_descriptions": [
            {
              "name": "Author",
              "data_type": "string"
            },
            {
              "name": "Publication Date",
              "data_type": "date"
            }
          ]
        }, headers: { "Authorization" => "Bearer #{token}"}
      }.to change { Collection.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "Put /collections/:id" do
    let!(:book_collection) { FactoryBot.create(:collection,
                                               name: "Books",
                                               description: "Collection of books",
                                               category: book_category,
                                               user: user_mohib,
                                               item_field_descriptions: [
                                                 {
                                                   "name": "Author",
                                                   "data_type": "string"
                                                 },
                                                 {
                                                   "name": "Publication Date",
                                                   "data_type": "date"
                                                 }
                                               ])}


    it "tries to update another user's collection" do
      token = AuthenticationTokenService.encode(user_musab)
      put "/api/collections/#{book_collection.id}", params: {
        name: "Books",
        description: "Collection of books",
        category_id: book_category.id,
        "item_field_descriptions": [
          {
            "name": "Author",
            "data_type": "string"
          },
          {
            "name": "Publication Date",
            "data_type": "date"
          }
        ]
      }, headers: { "Authorization" => "Bearer #{token}"}

      expect(response).to have_http_status(:unauthorized)
    end

  end
end