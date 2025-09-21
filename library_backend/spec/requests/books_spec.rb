require 'rails_helper'

RSpec.describe "Books", :aggregate_failures, type: :request do
  describe "POST /books" do
    context "when librarian request" do
      let(:librarian) { create(:librarian) }

      it "creates a new book" do
        book_params = {
          book: {
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            genre: "Fiction",
            isbn: "9780743273565",
            total_copies: 5
          }
        }

        post "/books", params: book_params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include(
          "title" => "The Great Gatsby",
          "author" => "F. Scott Fitzgerald",
          "genre" => "Fiction",
          "isbn" => "9780743273565",
          "total_copies" => 5
        )
      end

      it "returns error when required fields are missing" do
        book_params = {
          book: {
            title: ""
          }
        }
        post "/books", params: book_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"], "author" => ["can't be blank"], "genre" => ["can't be blank"], "isbn" => ["can't be blank"])
      end
    end
  end
end
