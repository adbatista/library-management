require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  it { is_expected.to validate_presence_of(:email_address) }
  it { is_expected.to validate_uniqueness_of(:email_address).case_insensitive }
  it { is_expected.to allow_value('a@a.com').for(:email_address) }
  it { is_expected.to_not allow_value('invalid_email').for(:email_address) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to define_enum_for(:user_type).with_values(member: "member", librarian: "librarian").backed_by_column_of_type(:string) }
end
