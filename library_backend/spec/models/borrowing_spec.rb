require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:book) }
  it { is_expected.to validate_presence_of(:borrowed_at) }

  describe 'available_copies validation' do
    let(:book) { create(:book, total_copies: 2) }

    it 'is valid when copies are available' do
      create(:borrowing, book: book)
      borrowing = build(:borrowing, book: book)
      expect(borrowing).to be_valid
    end

    it 'is not valid when no copies are available' do
      create_list(:borrowing, 2, book: book)
      borrowing = build(:borrowing, book: book)
      expect(borrowing).not_to be_valid
      expect(borrowing.errors[:base]).to include("No copies available for this book")
    end
  end

  describe 'due_date default value' do
    it 'sets due_date to two weeks from borrowed_at if not provided' do
      borrowing = create(:borrowing, borrowed_at: Time.current)
      expect(borrowing.due_date).to be_within(1.second).of(borrowing.borrowed_at + 2.weeks)
    end
  end

  describe '#due?' do
    it 'returns true if the borrowing is past due' do
      borrowing = create(:borrowing, borrowed_at: 3.weeks.ago)
      expect(borrowing).to be_due
    end

    it 'returns false if the borrowing is not past due' do
      borrowing = create(:borrowing, borrowed_at: 1.week.ago)
      expect(borrowing).not_to be_due
    end
  end
end
