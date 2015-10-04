class User < ActiveRecord::Base
  has_secure_password

  def to_s
    return self.name
  end
end
