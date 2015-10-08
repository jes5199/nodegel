class Softlink < ActiveRecord::Base
  validate :from_and_to_must_be_different

  def self.traverse(from_link, to_link)
    return unless from_link && to_link
    return if from_link.namespace != to_link.namespace
    return if from_link.name == to_link.name

    Softlink.transaction do
      softlink = Softlink.find_or_create_by(
          namespace: from_link.namespace,
          from_name: from_link.name,
          to_name: to_link.name
      )
      softlink.traversals += 1
      if softlink.save
        return softlink
      end
    end
  end

  def from_and_to_must_be_different
    if to_name == from_name
      errors.add(:to_name, "can't be equal to from_name")
    end
  end

  def to_s
    Link.new("/#{self.namespace}/#{self.to_name}", show_brackets: true).to_s
  end
end
