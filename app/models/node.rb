class Node < ActiveRecord::Base
  belongs_to :author, class_name: "User"

  def allowed_tags
      %w[i em strong b]
  end

  def allowed_attributes
      []
  end

  def sanitize(body)
    Rails::Html::WhiteListSanitizer.new().sanitize(body, tags: allowed_tags, attributes: allowed_attributes)
  end

  def linkify(bracket)
    text = bracket[1...-1]
    text, dest = text.split('|', 2)
    dest ||= text
    if dest[0] == '/'
        namespace, dest = dest.split('/', 2)
    else
        namespace = '.'
    end
    dest = dest.gsub('/', "\u2215")
    return ("<a href=\"" + namespace + "/" + dest +"\">" + text + "</a>")
  end

  def render_body
    return sanitize(self.body).gsub("\n", "<br>\n").gsub(/\[.*?\]/){|bracket| linkify bracket}.html_safe
  end
end
