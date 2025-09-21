class Session < ApplicationRecord
  has_secure_token
  belongs_to :user

  after_initialize :set_expires_at, if: :new_record?

  def expired?
    expires_at.past?
  end

  private

  def set_expires_at
    self.expires_at ||= 1.day.from_now
  end
end
