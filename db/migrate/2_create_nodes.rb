class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :users, :author, index: true
      t.string :namespace, index: true
      t.string :name, index: true
      t.string :noun_type
      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :nodes, :users, column: :author_id
    add_index :nodes, [:namespace, :name, :author_id], unique: true
  end
end
