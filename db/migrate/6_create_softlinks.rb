class CreateSoftlinks < ActiveRecord::Migration
  def change
    create_table :softlinks do |t|
      t.string :namespace, null: false
      t.string :from_name, null: false
      t.string :to_name, null: false
      t.integer :traversals, null: false, default: 0

      t.timestamps null: false
    end
  end
end
