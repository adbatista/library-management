FactoryBot.define do
  factory :user do
    user_type { [ "member", "librarian" ].sample }
    sequence(:name) { "User #{_1}" }
    sequence(:email_address) { "user#{_1}@example.com" }
    password { "password" }

    factory :member do
      user_type { "member" }
    end

    factory :librarian do
      user_type { "librarian" }
    end
  end
end
