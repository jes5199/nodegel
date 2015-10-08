class Node < ActiveRecord::Base
  belongs_to :author, class_name: "User"

  def allowed_tags
      %w[i em strong b]
  end

  def allowed_attributes
      []
  end

  def unspecial(text)
    text = text.gsub("\u00A0",' ')
    text = text.gsub("\u2215",'/')
  end

  def sanitize(body)
    Rails::Html::WhiteListSanitizer.new().sanitize(body, tags: allowed_tags, attributes: allowed_attributes)
  end

  def linkify(bracket)
    text = bracket[1...-1]
    return Hardlink.new(text, self)
  end

  def editable_body
    return unspecial(self.body || '')
  end

  def render_body
    body = self.body
    body = unspecial(body)
    body = sanitize(body)
    body = body.gsub(/\r?\n/, "<br>\r\n")
    body = body.gsub(/\[.*?\]/){|bracket| linkify bracket}
    return body.html_safe
  end

  def to_s
    "/" + [self.namespace, self.name, self.author].join('/')
  end

  def node_time
    return NodeTime.new(updated_at)
  end

  def written_or_updated
    if updated_at - created_at < 12.hours
      return "written"
    else
      return "updated"
    end
  end

  def link
    return Link.new("/#{@namespace}/#{@name}/#{@author}")
  end
end
