class User < ActiveRecord::Base
  has_secure_password
  validates_format_of :name, with: /\A[''a-zA-Z0-9!?. _-]+\z/
  validate :no_weird_spacing

  def to_s
    return self.name
  end

  def no_weird_spacing
    if name != name.strip.gsub("  ", " ")
      errors.add(:name, "can't have weird spaces")
    end
  end
end
