class Softlink < ActiveRecord::Base
  def self.traverse(from_link, to_link)
    return if from_link.namespace != to_link.namespace
    return if from_link.name == to_link.name

    softlink = Softlink.find_or_create_by(
        namespace: from_link.namespace,
        from_name: from_link.name,
        to_name: to_link.name
    )
    softlink.traversals += 1
    softlink.save!
    return softlink
  end
end
