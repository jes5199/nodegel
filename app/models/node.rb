class Node < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  validates_inclusion_of :noun_type, :in => %w[person place thing idea], :allow_nil => true
  has_many :annotationlinks

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

  def render_body(as_user = nil)
    body = self.body.to_s
    body = unspecial(body)
    body = sanitize(body)
    body = body.gsub(/\[[^\[]*?\]/){|bracket| linkify bracket}
    body = body.gsub(/\r?\n/, "<br>\r\n")
    annotationlinks.order(:id).each do |annotationlink|
      body = annotationlink.annotate_html(body, as_user)
    end
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

  def link(to_author = false)
    return Link.to(namespace, name, to_author ? author : nil)
  end

  def self.search(field, namespace, content, limit = 10)
    matcher = content.gsub(/[_%\\]/){|x| "\\#{x}"}
    matcher = "%#{matcher}%"
    Node.where(namespace: namespace) \
        .where("#{field} LIKE ?", matcher) \
        .where("name != ?", content) \
        .limit(limit) \
        .order(name: 'asc', updated_at: 'desc') \
        .pluck("distinct on (name) name, updated_at") \
        .map{|name, updated_at| Link.to(namespace, name, nil, show_brackets: true)}
  end
end
