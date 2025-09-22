class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at,  presence: true
  validate :available_copies, on: :create
  validates :book_id, uniqueness: { scope: :user_id, message: "You already borrowed this book" }

  attribute :borrowed_at, :datetime, default: -> { DateTime.current }

  def due_date
    borrowed_at + 2.weeks
  end

  def due?
    due_date.past?
  end

  private

  def available_copies
    if book && !book.has_available_copies?
      errors.add(:base, "No copies available for this book")
    end
  end
end
