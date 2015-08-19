class NodeController < ApplicationController
  def view
      @name = params[:name]
      @nodes = Node.where(name: @name)
      @nodes = [Node.new(name: @name, body: "hello I am node", author: User.new(name: "jes"), created_at: Time.now)]
  end

  def zoom
      #(name, author)
  end

  def edit
      #(name)
  end
end
