class BorrowingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_borrowing, only: %i[ show update ]

  # GET /borrowings
  def index
    @borrowings = Borrowing.accessible_by(current_ability)

    render json: @borrowings
  end

  # GET /borrowings/1
  def show
    render json: @borrowing
  end

  # POST /borrowings
  def create
    @borrowing = Borrowing.new(borrowing_params) { |b| b.user = current_user }

    if @borrowing.save
      render json: @borrowing, status: :created, location: @borrowing
    else
      render json: @borrowing.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /borrowings/1
  def update
    if @borrowing.update(params.expect(borrowing: [ :returned_at ]))
      render json: @borrowing
    else
      render json: @borrowing.errors, status: :unprocessable_content
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_borrowing
      @borrowing = Borrowing.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def borrowing_params
      params.expect(borrowing: [ :book_id ])
    end
end
