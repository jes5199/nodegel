class Hardlink
  def initialize(content, current_node)
    @content = content
    @current_node = current_node
  end

  def to_s
    text, dest = @content.split('|', 2)
    if dest
      Link.new(dest, text: text, from_node: @current_node).to_s
    else
      Link.new(text, from_node: @current_node).to_s
    end
  end
end
