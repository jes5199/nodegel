class Link
  def initialize(destination, extra = {})
    @destination = destination
    @from_node = extra[:from_node]
    @text = extra[:text]
    @show_brackets = extra[:show_brackets]
    @klass = extra[:klass]
    @namespace, @name, @author = parse_link(@destination)
  end
  attr_reader :namespace, :name, :author

  def self.to(namespace, name, author = nil, extra = {})
      namespace = deslash(namespace)
      name = deslash(name)
      if author
        Link.new("/#{namespace}/#{name}/#{author}", extra)
      else
        Link.new("/#{namespace}/#{name}", extra)
      end
  end

  def hash
    [Link, @namespace, @name, @author, @text].hash
  end

  def eql?(other)
    other.hash == self.hash
  end

  def to_s
    return format_link(@namespace, @name, @author, link_text)
  end

  def to_href
    return format_href(@namespace, @name, @author)
  end

  def self.fake_slash
    return "\u2215"
  end

  def self.fake_question
    return "\uFE56"
  end

  def self.reslash(urlpart)
    urlpart.gsub(fake_slash, '/')
  end

  def self.deslash(urlpart)
    urlpart.gsub('/', fake_slash)
  end

  def unfakespace(s)
    s.gsub("\u00A0",' ')
  end

  def unfakequestion(s)
    s.gsub(self.class.fake_question,'?')
  end

  def parse_link(link)
    if !link || link.strip.empty?
      link = @from_node.to_s
    end
    if link == '/'
      return "*", "welcome home"
    end
    if link == '..'
      return @from_node.namespace, nil, nil
    end
    if link == '.'
      return @from_node.namespace, @from_node.name, nil
    end
    link = unfakespace(link)
    link = unfakequestion(link)
    link = link.split(/\s+/).join(" ")
    if link[0] == '/'
      parts = link[1..-1].split('/', -1)
      namespace = parts.shift
      if parts.length > 1
        author = parts.pop
        if author.blank?
          author = nil
        end
      end
      name = parts.join(self.class.fake_slash)
      name = name.strip
      if name.empty?
        name = nil
      end
    else
      namespace = nil
      author = nil
      name = self.class.reslash(link).strip
    end
    if namespace =~ /^\s+$/
      namespace = " "
    end
    if namespace && namespace != ' '
      namespace = namespace.strip
    end
    if namespace == '.'
      namespace = nil
    end
    if namespace == '..'
      namespace = "\u2042" #asterism
    end
    return namespace, name, author
  end

  def d(urlpart)
    return self.class.deslash(urlpart)
  end

  def r(urlpart)
    return self.class.reslash(urlpart)
  end

  def format_link(namespace, name, author, text)
    #TODO: support namespace aliveness
    alive_nodes = Node.where(name: d(name.to_s), namespace: namespace || @from_node.namespace )
    if author
      alive_nodes = alive_nodes.where(author: User.find_by_name(author))
    end
    alive = alive_nodes.any?
    href = format_href(namespace, name, author)
    return ("<a href=\"" + href + "\" class=\"" + (alive ? "link" : "new-link") + " " + @klass.to_s + "\">" + link_text + "</a>").html_safe
  end

  def format_href(namespace, name, author)
    href = ""
    if namespace
      href = "/" + d(namespace)
      if name
         href += "/" + d(name)
      end
    else
      href = "./" + d(name)
    end
    if author
      href += "/" + d(author)
    end
    href.gsub!('?', self.class.fake_question)
    return URI.encode(href)
  end

  def link_text
    text = (@text || @name || @namespace || '').strip
    text = "[#{text}]" if @show_brackets
    return text
  end

  def self.from_referrer(referrer)
    if referrer
      uri = URI.parse(referrer)
      return Link.new(URI.decode(uri.path).force_encoding("utf-8"))
    end
  end
end
