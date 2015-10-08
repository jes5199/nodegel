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
      from_link = Link.new(URI.decode(uri.path).force_encoding("utf-8"))
      to_link = Link.new("/#{@namespace}/#{@name}")
      Softlink.traverse(from_link, to_link)
      if from_link.namespace == @namespace
        softlink = Softlink.find_or_create_by(namespace: @namespace, from_name: from_link.name, to_name: @name)
        softlink.traversals += 1
        softlink.save!
      end
    end
    @softlinks = Softlink.where(namespace: @namespace, from_name: @name).order("traversals / Extract(EPOCH from (Now() - created_at)) DESC").limit(10)
  end

  def zoom
    return render :not_ready
  end
end
