class NodeController < ApplicationController
  def node
    if URI.parse(request.env["REQUEST_URI"]).path != URI.parse(request.url).path
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
    current_link = Link.new("/#{@namespace}/#{@name}")

    if request.post?
      @your_node.body = params[:node]
      @your_node.noun_type = params[:noun_type]
      @your_node.save!
    else
      NoderPresence.say_to_url(current_link.to_href, {user: current_user.to_s, action: 'arrived'})
    end
    from_link = Link.from_referrer(request.referrer)
    if from_link
      Softlink.traverse(from_link, current_link)
    end
    @softlinks = Softlink.where(namespace: @namespace, from_name: @name).order("traversals / Extract(EPOCH from (Now() - created_at)) DESC").limit(10)
    @search_results = (Node.search('name', @namespace, @name) + Node.search('body', @namespace, @name)).uniq
  end

  def go
    from_link = Link.from_referrer(request.referrer)
    @namespace = params[:namespace]
    @name = params[:name]
    if @name.present?
      to_link = Link.new("/#{@namespace}/#{@name}")
    elsif from_link
      to_link = from_link
    else
      to_link = Link.new("/*/welcome home")
    end
    Softlink.traverse(from_link, to_link)
    return redirect_to(to_link.to_href)
  end

  def zoom
    return render :not_ready
  end
end
