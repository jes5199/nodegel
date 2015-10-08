require 'faye/websocket'

class NoderPresence
  KEEPALIVE_TIME = 5 # in seconds

  def initialize(app)
    @app     = app
    @client_urls = {}
    @url_clients = Hash.new{|h,k| h[k] = []}
    @@singleton = self
  end

  def self.say_to_url(url, data)
    if @@singleton
      @@singleton.say_to_url(url, data)
    end
  end

  def say_to_url(url, data)
    p [:saying, url, data]
    @url_clients[url].each do |client|
      p [:saying, url, client.object_id]
      client.send(JSON.dump(data))
    end
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
      ws.on :open do |event|
        url = URI.parse(RespaceUrl.unspace(ws.url)).path
        p [:open, ws.object_id, url]
        @client_urls[ws] = url
        @url_clients[url] << ws
      end
      ws.on :message do |event|
        p [:message, ws.object_id, url, event.data]
      end
      ws.on :close do |event|
        url = @client_url.delete(ws)
        p [:close, ws.object_id, url, event.code, event.reason]
        @url_clients[url].delete(ws)
        ws = nil
      end

      ws.rack_response
    else
      @app.call(env)
    end
  end
end
