require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { build(:book) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:author) }
  it { is_expected.to validate_presence_of(:genre) }
  it { is_expected.to validate_presence_of(:isbn) }
  it { is_expected.to validate_presence_of(:total_copies) }
  it { is_expected.to validate_uniqueness_of(:isbn).case_insensitive }
  it { is_expected.to validate_numericality_of(:total_copies).only_integer.is_greater_than_or_equal_to(0) }

  describe '.search' do
    let!(:book1) { create(:book, title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', genre: 'Fiction') }
    let!(:book2) { create(:book, title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Fiction') }
    let!(:book3) { create(:book, title: 'A Brief History of Time', author: 'Stephen Hawking', genre: 'Science') }

    context 'when term is blank' do
      it 'returns all books' do
        expect(Book.search('')).to match_array([ book1, book2, book3 ])
      end
    end
    context 'when term matches title' do
      it 'returns matching books' do
        expect(Book.search('Gatsb')).to eq([ book1 ])
      end
    end
    context 'when term matches author' do
      it 'returns matching books' do
        expect(Book.search('Harper')).to eq([ book2 ])
      end
    end
    context 'when term matches genre' do
      it 'returns matching books' do
        expect(Book.search('Science')).to eq([ book3 ])
      end
    end
    context 'when term matches multiple books' do
      it 'returns all matching books' do
        expect(Book.search('Fiction')).to match_array([ book1, book2 ])
      end
    end
    context 'when term matches no books' do
      it 'returns an empty array' do
        expect(Book.search('Nonexistent')).to be_empty
      end
    end
  end

  describe '#has_available_copies?' do
    subject(:book) { create(:book, total_copies: 2) }

    context 'when there are available copies' do
      before do
        create_list(:borrowing, 2, book: book, returned_at: Time.current)
      end

      it 'returns true' do
        expect(book).to have_available_copies
      end
    end

    context 'when there are no available copies' do
      before do
        create_list(:borrowing, 2, book: book, returned_at: nil)
      end

      it 'returns false' do
        expect(book).not_to have_available_copies
      end
    end
  end
end
