FactoryBot.define do
  factory :book do
    sequence(:title) { "Book title #{_1}" }
    sequence(:author) { "Author #{_1}" }
    genre { ["Fiction", "Comedy", "Terror"] }
    isbn { "9780743273565" }
    total_copies { (1..100).to_a.sample }
  end
end
