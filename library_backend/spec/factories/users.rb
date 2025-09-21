FactoryBot.define do
  factory :user do
    user_type { [ "member", "librarian" ].sample }
    sequence(:name) { |n| "User #{n}" }
    email_address { "user@example.com" }
    password { "password" }

    factory :member do
      user_type { "member" }
    end

    factory :librarian do
      user_type { "librarian" }
    end
  end
end
