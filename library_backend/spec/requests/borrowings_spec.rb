require 'rails_helper'

RSpec.describe "Borrowings", :aggregate_failures, type: :request do
  describe "POST /borrowings" do
    context "when not authenticated" do
      it "returns unauthorized status" do
        post "/borrowings", params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }
      let(:book) { create(:book, total_copies: 3) }

      it "creates a new borrowing" do
        borrowing_params = {
          borrowing: {
            book_id: book.id
          }
        }

        post "/borrowings", params: borrowing_params, headers: { "Authorization" => "Bearer #{session.token}" }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include(
          "user_id" => member.id,
          "book_id" => book.id
        )
      end

      it "returns error when required fields are missing" do
        borrowing_params = {
          borrowing: {
            book_id: nil
          }
        }
        post "/borrowings", params: borrowing_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to include("book" => [ "must exist" ])
      end

      it "returns error when no copies are available" do
        create_list(:borrowing, 3, book: book)

        borrowing_params = {
          borrowing: {
            book_id: book.id
          }
        }

        post "/borrowings", params: borrowing_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to include("base" => [ "No copies available for this book" ])
      end

      it "does not allow a member to book the same book multiple times" do
        create(:borrowing, book: book, user: member)

        borrowing_params = {
          borrowing: {
            book_id: book.id
          }
        }

        post "/borrowings", params: borrowing_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to include("book_id" => [ "You already borrowed this book" ])
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }
      let(:book) { create(:book) }

      it "returns forbidden status" do
        borrowing_params = {
          borrowing: {
            book_id: book.id
          }
        }
        post "/borrowings", params: borrowing_params, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET /borrowings" do
    context "when not authenticated" do
      it "returns unauthorized status" do
        get "/borrowings"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }
      let!(:borrowings) { create_list(:borrowing, 2, user: member) }

      before do
        other_member = create(:member)
        create(:borrowing, user: other_member)
      end

      it "returns only the member borrowings" do
        get "/borrowings", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }
      let!(:borrowings) { create_list(:borrowing, 3) }

      it "returns all borrowings" do
        get "/borrowings", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).count).to eq(3)
      end
    end
  end

  describe "GET /borrowings/:id" do
    context "when not authenticated" do
      it "returns unauthorized status" do
        get "/borrowings/1"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }
      let(:borrowing) { create(:borrowing, user: member) }

      it "returns the borrowing" do
        get "/borrowings/#{borrowing.id}", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          borrowing.slice(:id, :borrowed_at, :returned_at, :created_at, :updated_at, :due_date).as_json.merge(
          "user" => borrowing.user.slice(:id, :name, :email_address),
          "book" => borrowing.book.slice(:id, :title, :author, :genre, :isbn)
          )
        )
      end

      it "returns forbidden when accessing another user's borrowing" do
        other_member = create(:member)
        other_borrowing = create(:borrowing, user: other_member)

        get "/borrowings/#{other_borrowing.id}", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }
      let(:borrowing) { create(:borrowing) }

      it "returns the borrowing" do
        get "/borrowings/#{borrowing.id}", headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          borrowing.slice(:id, :borrowed_at, :returned_at, :created_at, :updated_at, :due_date).as_json.merge(
          "user" => borrowing.user.slice(:id, :name, :email_address),
          "book" => borrowing.book.slice(:id, :title, :author, :genre, :isbn)
          )
        )
      end
    end
  end

  describe "PUT /borrowings/:id" do
    context "when not authenticated" do
      it "returns unauthorized status" do
        put "/borrowings/1", params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when member request" do
      let(:member) { create(:member) }
      let(:session) { create(:session, user: member) }
      let(:borrowing) { create(:borrowing, user: member, returned_at: nil) }

      it "returns forbidden when updating borrowing" do
        put "/borrowings/#{borrowing.id}", params: { borrowing: { returned_at: DateTime.now } }, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when librarian request" do
      let(:librarian) { create(:librarian) }
      let(:session) { create(:session, user: librarian) }

      it "returns forbidden status when updating an already returned book" do
        borrowing = create(:borrowing, returned_at: Date.current)
        put "/borrowings/#{borrowing.id}", params: { borrowing: { returned_at: DateTime.now } }, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:forbidden)
      end

      it "updates the borrowing to set returned_at" do
        borrowing = create(:borrowing, returned_at: nil)
        put "/borrowings/#{borrowing.id}", params: { borrowing: { returned_at: DateTime.now } }, headers: { "Authorization" => "Bearer #{session.token}" }
        expect(response).to have_http_status(:ok)

        expect(JSON.parse(response.body)).to include(
          "id" => borrowing.id,
          "returned_at" => be_present
        )
      end
    end
  end
end
