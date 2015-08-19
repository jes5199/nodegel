class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :author, index: true, foreign_key: true
      t.string :name, index: true
      t.string :noun_type
      t.text :body

      t.timestamps null: false
    end
  end
end
