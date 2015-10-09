class Annotationlink < ActiveRecord::Base
  belongs_to :user
  belongs_to :node
  SAFE_TEXT_REGEX = /\A[^\[\]<>\n]+\z/
  validates_format_of :text, with: SAFE_TEXT_REGEX
  validates_format_of :destination, with: SAFE_TEXT_REGEX

  def annotate(content)
    content.sub(self.pattern, self.link)
  end

  def matches(content)
    content =~ self.pattern
  end

  def pattern
    Regexp.new(Regexp.escape(self.text).gsub(/\s+/, ' +'))
  end

  def link
    Link.to(node.namespace, destination, nil, text: text + "<sup> #{user.to_s}</sup>", :klass => "annotation-link").to_s
  end
end
