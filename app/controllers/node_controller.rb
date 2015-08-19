class NodeController < ApplicationController
  def view
      @name = params[:name]
      @nodes = Node.where(name: @name)
      @your_node = @nodes.where(author: current_user).first()
  end

  def zoom
      #(name, author)
  end

  def edit
      #(name)
  end
end
