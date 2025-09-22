json.extract! borrowing, :id, :borrowed_at, :returned_at, :due_date, :created_at, :updated_at
json.user do
  json.extract! borrowing.user, :id, :name, :email_address
end
json.book do
  json.extract! borrowing.book, :id, :title, :author, :genre, :isbn
end

json.url borrowing_url(borrowing, format: :json)
