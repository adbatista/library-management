class Book < ApplicationRecord
  validates :title, :author, :genre, :isbn, :total_copies, presence: true
  validates :isbn, uniqueness: { case_sensitive: false }
  validates :total_copies, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
