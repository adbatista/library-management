class Book < ApplicationRecord
  validates :title, :author, :genre, :isbn, :total_copies, presence: true
  validates :isbn, uniqueness: { case_sensitive: false }
  validates :total_copies, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :borrowings, dependent: :destroy

  def has_available_copies?
    borrowings.where(returned_at: nil).count < total_copies
  end
end
