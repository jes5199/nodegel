class NodeController < ApplicationController
  def node
    if request.env["REQUEST_URI"] != request.url
      return redirect_to(request.url)
    end
    @namespace = params[:namespace]
    if @namespace == " "
        return redirect_to('/')
    end
    if @namespace != "*"
      return render :not_ready
    end
    @name = params[:name]
    @nodes = Node.where(name: @name, namespace: @namespace).order(updated_at: :desc)
    @your_node = @nodes.where(author: current_user).first() || Node.new(name: @name, author: current_user, namespace: @namespace)
    if request.post?
      @your_node.body = params[:node]
      @your_node.save!
    end
    if request.referrer
      uri = URI.parse(request.referrer)
      from_link = Link.new(uri.path)
      if from_link.namespace == @namespace
        softlink = Softlink.find_or_create_by(namespace: @namespace, from_name: from_link.name, to_name: @name)
        softlink.traversals += 1
        softlink.save!
      end
    end
  end

  def zoom
    return render :not_ready
  end
end
