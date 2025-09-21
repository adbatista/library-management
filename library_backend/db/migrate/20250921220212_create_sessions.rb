class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent
      t.string :token, null: false, index: { unique: true }
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
