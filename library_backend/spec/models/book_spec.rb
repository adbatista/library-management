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
