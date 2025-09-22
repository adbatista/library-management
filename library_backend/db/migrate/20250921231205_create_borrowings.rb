class CreateBorrowings < ActiveRecord::Migration[8.0]
  def change
    create_table :borrowings do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.references :book, null: false, foreign_key: true
      t.datetime :returned_at

      t.timestamps
    end

    add_index :borrowings, [ :user_id, :book_id ], unique: true, name: "index_unique_active_borrowings_on_user_and_book"
  end
end
