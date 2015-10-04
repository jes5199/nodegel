class NodeController < ApplicationController
  def node
    @name = params[:name]
    @nodes = Node.where(name: @name)
    @your_node = @nodes.where(author: current_user).first() || Node.new(name: @name, author: current_user)
    if request.post?
        @your_node.body = params[:node]
        @your_node.save!
        @nodes = Node.where(name: @name)
    end
  end

  def zoom
      #(name, author)
  end
end
