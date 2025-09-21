FactoryBot.define do
  factory :user do
    user_type { ["member", "librarian"].sample }
    sequence(:name) { |n| "User #{n}" }
    email_address { "user@example.com" }
    password { "password" }
  end
end
