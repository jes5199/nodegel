class Presence < ActiveRecord::Base
  belongs_to :user

  def self.saw_user_at(user_id, namespace, name)
    self.find_or_create_by(user_id: user_id).move_to(namespace, name)
  end

  def move_to(namespace, name)
    return if self.namespace == namespace && self.name == name

    self.previous_namespace = self.namespace
    self.previous_name = self.name
    self.namespace = namespace
    self.name = name
    self.verbing = nil
    self.save
    Softlink.traverse(previous_link, to_link)
    NoderPresence.say_to_url(previous_link.to_href, {user: user.to_s, presence: self.id, action: 'departed', when: Time.now.to_i, to: [namespace, name]})
    NoderPresence.say_to_url(to_link.to_href, {user: user.to_s, presence: self.id, action: 'arrived', when: Time.now.to_i, from: [previous_namespace, previous_name]})
  end

  def previous_link
    Link.new("/#{previous_namespace}/#{previous_name}")
  end

  def to_link
    Link.new("/#{namespace}/#{name}")
  end
end
