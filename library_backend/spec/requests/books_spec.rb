require 'rails_helper'

RSpec.describe "Books", :aggregate_failures, type: :request do
  describe "POST /books" do
    context "when not authenticated" do
      it "returns unauthorized status" do
        post "/books", params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }

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

        post "/books", params: book_params, headers: { "Authorization" => "Bearer #{session.token}" }
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
        post "/books", params: book_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to include("title" => [ "can't be blank" ], "author" => [ "can't be blank" ], "genre" => [ "can't be blank" ], "isbn" => [ "can't be blank" ])
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }

      it "returns forbidden status" do
        book_params = {
          book: {
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            genre: "Fiction",
            isbn: "9780743273565",
            total_copies: 5
          }
        }

        post "/books", params: book_params, headers: { "Authorization" => "Bearer #{session.token}" }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT /books/:id" do
    let(:book) { create(:book) }

    context "when not authenticated" do
      it "returns unauthorized status" do
        put "/books/#{book.id}", params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }

      it "updates the book" do
        update_params = {
          book: {
            title: "Updated Title"
          }
        }

        put "/books/#{book.id}", params: update_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("title" => "Updated Title")
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }

      it "returns forbidden status" do
        update_params = {
          book: {
            title: "Updated Title"
          }
        }

        put "/books/#{book.id}", params: update_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /books/:id" do
    let(:book) { create(:book) }

    context "when not authenticated" do
      it "returns unauthorized status" do
        delete "/books/#{book.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }

      it "deletes the book" do
        delete "/books/#{book.id}", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:no_content)
        expect(Book.find_by(id: book.id)).to be_nil
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }

      it "returns forbidden status" do
        delete "/books/#{book.id}", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /books" do
    let!(:books) { create_list(:book, 3) }

    context "when not authenticated" do
      it "returns unauthorized status" do
        get "/books"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when authenticated as member" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }

      it "returns the list of books" do
        get "/books", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match_array(books.as_json)
      end
    end

    context "when authenticated as librarian" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }

      it "returns the list of books" do
        get "/books", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match_array(books.as_json)
      end
    end

    it "filters books by genre" do
      fiction_book = create(:book, genre: "Drama")
      _non_fiction_book = create(:book, genre: "Comedy")
      member = create(:member)
      session = create(:session, user: member)

      get "/books", params: { term: "Drama" }, headers: { "Authorization" => "Bearer #{session.token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([ fiction_book.as_json ])
    end

    it "searches books by title" do
      book1 = create(:book, title: "The Great Gatsby", author: "F. Scott Fitzgerald")
      _book2 = create(:book, title: "To Kill a Mockingbird", author: "Harper Lee")
      member = create(:member)
      session = create(:session, user: member)

      get "/books", params: { term: "Gatsby" }, headers: { "Authorization" => "Bearer #{session.token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([ book1.as_json ])
    end

    it "searches books by author" do
      book1 = create(:book, title: "To Kill a Mockingbird", author: "Harper Lee")
      _book2 = create(:book, title: "The Great Gatsby", author: "F. Scott Fitzgerald")
      member = create(:member)
      session = create(:session, user: member)

      get "/books", params: { term: "Harper" }, headers: { "Authorization" => "Bearer #{session.token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([ book1.as_json ])
    end
  end
end
