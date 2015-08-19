class Invite < ActiveRecord::Base
  belongs_to :from_user
  belongs_to :created_user
end
