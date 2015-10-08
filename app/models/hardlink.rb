class Hardlink
  def initialize(content, current_node)
    @content = content
    @current_node = current_node
  end

  def to_s
    dest, text = @content.split('|', 2)
    if text
      Link.new(dest, text: text, from_node: @current_node).to_s
    else
      Link.new(dest, from_node: @current_node).to_s
    end
  end
end
