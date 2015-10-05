class UniqueInviteKeys < ActiveRecord::Migration
  def change
    add_index :invites, [:key], :unique => true
  end
end
