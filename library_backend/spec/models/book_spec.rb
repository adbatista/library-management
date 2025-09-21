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
end
