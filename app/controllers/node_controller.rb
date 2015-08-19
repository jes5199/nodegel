class NodeController < ApplicationController
  def view
      @name = params[:name]
      @nodes = Node.where(name: @name)
  end

  def zoom
      #(name, author)
  end

  def edit
      #(name)
  end
end
