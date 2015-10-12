class Annotationlink < ActiveRecord::Base
  belongs_to :user
  belongs_to :node
  SAFE_TEXT_REGEX = /\A[^\[\]<>\n]+\z/
  validates_format_of :text, with: SAFE_TEXT_REGEX
  validates_format_of :destination, with: SAFE_TEXT_REGEX

  def annotate_text(content, as_user = nil)
    content.sub(self.pattern, self.link(as_user))
  end

  def annotate_html(body, as_user = nil)
    html = Nokogiri::HTML("<html><body><p>"+body+"</p></body></html>")
    html.xpath('/html/body/p/text()').each do |text|
    if self.matches(text.content)
      text.replace(self.annotate_text(text.content, as_user))
        break
      end
    end
    return html.xpath('/html/body/p').children.to_s
  end

  def matches(content)
    content =~ self.pattern
  end

  def pattern
    Regexp.new(Regexp.escape(self.text).gsub(/\s+/, ' +'))
  end

  def link(as_user = nil)
    link = Link.to(node.namespace, destination, nil, text: text + "<sup> #{user.to_s}</sup>", :klass => "annotation-link").to_s
    if as_user == user
      link += " <sup class=\"unannotate\" annotation_id=\"#{id}\">(x)</sup>".html_safe
    end
    return link
  end
end
