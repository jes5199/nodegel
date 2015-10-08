class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.references :user, index: false, foreign_key: true
      t.string :namespace
      t.string :name
      t.string :previous_namespace
      t.string :previous_name
      t.string :verbing

      t.timestamps null: false
    end
    add_index :presences, [:user_id], :unique => true
  end
end
