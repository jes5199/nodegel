class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :users, :from_user, index: true
      t.string :key
      t.references :users, :created_user, index: true

      t.timestamps null: false
    end
    add_foreign_key :invites, :users, column: :from_user_id
    add_foreign_key :invites, :users, column: :created_user_id
  end
end
