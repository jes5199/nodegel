class Invite < ActiveRecord::Base
  belongs_to :from_user, class_name: "User"
  belongs_to :created_user, class_name: "User"

  def random_word
    @random ||= Random.new
    @words ||= File.open('/usr/share/dict/words').lines.to_a
    return @words[@random.rand(@words.length)].downcase.strip
  end

  def activate
    if not self.key.blank?
      return
    end
    key = ""
    3.times do
      key += " " + random_word
    end
    key.strip!
    while Invite.where(key: key).count > 0
      key = random_word + " " + key
    end
    self.key = key
    self.save!
  end
end
