class CreateAnnotationlinks < ActiveRecord::Migration
  def change
    create_table :annotationlinks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :node, index: true, foreign_key: true
      t.string :text
      t.string :destination

      t.timestamps null: false
    end
  end
end
