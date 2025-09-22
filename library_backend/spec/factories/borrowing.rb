FactoryBot.define do
  factory :borrowing do
    association :user
    association :book
    borrowed_at { DateTime.now }
    returned_at { nil }
  end
end
