class UniqueSoftlinks < ActiveRecord::Migration
  def change
    add_index :softlinks, [:namespace, :from_name, :to_name], :unique => true
  end
end
