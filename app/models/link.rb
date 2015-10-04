class Link
  def initialize(content, current_node)
    @content = content
    @current_node = current_node
  end

  def to_s
    text, dest = @content.split('|', 2)
    if dest
      return format_with_destination(text, dest)
    else
      return format_direct(text)
    end
  end

  def fake_slash
    return "\u2215"
  end

  def unfakespace(s)
    s.gsub("\u00A0",' ')
  end

  def parse_link(link)
    link ||= @current_node.to_s
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
    else
      namespace = nil
      author = nil
      name = link.gsub('/', fake_slash)
    end
    if namespace == '.'
      namespace = nil
    end
    if namespace == '..'
      namespace = "\u2042" #asterism
    end
    return namespace, name, author
  end

  def format_direct(text)
    namespace, name, author = parse_link(text)
    return format_link(namespace, name, author, name)
  end

  def format_with_destination(text, dest)
    namespace, name, author = parse_link(dest)
    return format_link(namespace, name, author, text)
  end

  def deslash(urlpart)
    urlpart.gsub('/', "\u2215")
  end

  def d(urlpart)
    return deslash(urlpart)
  end

  def format_link(namespace, name, author, text)
    alive_nodes = Node.where(name: name, namespace: namespace || @current_node.namespace )
    if author
      alive_nodes = alive_nodes.where(author: User.find_by_name(author))
    end
    alive = alive_nodes.any?
    if namespace
      link = "/" + d(namespace) + "/" + d(name)
    else
      link = "./" + d(name)
    end
    if author
      link += "/" + d(author)
    end
    return ("<a href=\"" + link + "\" class=\"" + (alive ? "link" : "new-link") + "\">" + text + "</a>")
  end
end
