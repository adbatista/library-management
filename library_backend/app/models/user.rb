class User < ApplicationRecord
  has_secure_password reset_token: false
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true

  enum :user_type, { member: "member", librarian: "librarian" }
end
