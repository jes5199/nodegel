class Link
  def initialize(destination, extra = {})
    @destination = destination
    @from_node = extra[:from_node]
    @text = extra[:text]
    @namespace, @name, @author = parse_link(@destination)
  end
  attr_reader :namespace, :name, :author

  def to_s
    return format_link(@namespace, @name, @author, @text || @name || @namespace)
  end

  def fake_slash
    return "\u2215"
  end

  def unfakespace(s)
    s.gsub("\u00A0",' ')
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
    if link[0] == '/'
      parts = link[1..-1].split('/', -1)
      namespace = parts.shift
      if parts.length > 1
        author = parts.pop
        if author.blank?
          author = nil
        end
      end
      name = parts.join(fake_slash)
      name = name.strip
      if name.empty?
        name = nil
      end
    else
      namespace = nil
      author = nil
      name = link.gsub('/', fake_slash).strip
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

  def deslash(urlpart)
    urlpart.gsub('/', "\u2215")
  end

  def d(urlpart)
    return deslash(urlpart)
  end

  def format_link(namespace, name, author, text)
    alive_nodes = Node.where(name: name, namespace: namespace || @from_node.namespace )
    if author
      alive_nodes = alive_nodes.where(author: User.find_by_name(author))
    end
    alive = alive_nodes.any?
    if namespace
      link = "/" + d(namespace)
      if name
         link += "/" + d(name)
      end
    else
      link = "./" + d(name)
    end
    if author
      link += "/" + d(author)
    end
    return ("<a href=\"" + link + "\" class=\"" + (alive ? "link" : "new-link") + "\">" + text.strip + "</a>")
  end
end
