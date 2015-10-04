class NodeController < ApplicationController
  def node
    if request.env["REQUEST_URI"] != request.url
      return redirect_to(request.url)
    end
    @namespace = params[:namespace]
    if @namespace != "*"
      return render :not_ready
    end
    @name = params[:name]
    @nodes = Node.where(name: @name, namespace: @namespace)
    @your_node = @nodes.where(author: current_user).first() || Node.new(name: @name, author: current_user, namespace: @namespace)
    if request.post?
      @your_node.body = params[:node]
      @your_node.save!
    end
  end

  def zoom
    return render :not_ready
  end
end
