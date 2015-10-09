class Annotationlink < ActiveRecord::Base
  belongs_to :user
  belongs_to :node
  SAFE_TEXT_REGEX = /\A[^\[\]<>\n]+\z/
  validates_format_of :text, with: SAFE_TEXT_REGEX
  validates_format_of :destination, with: SAFE_TEXT_REGEX

  def annotate_text(content)
    content.sub(self.pattern, self.link)
  end

  def annotate_html(body)
    html = Nokogiri::HTML("<html><body><p>"+body+"</p></body></html>")
    html.xpath('/html/body/p/text()').each do |text|
    if self.matches(text.content)
      text.replace(self.annotate_text(text.content))
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

  def link
    Link.to(node.namespace, destination, nil, text: text + "<sup> #{user.to_s}</sup>", :klass => "annotation-link").to_s
  end
end
