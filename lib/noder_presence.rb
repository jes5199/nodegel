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
      ws = Faye::WebSocket.new(env)
      ws.on :open do |event|
        begin
            url = URI.parse(RespaceUrl.unspace(ws.url)).path
            @client_urls[ws] = url
            @url_clients[url] << ws
        rescue => e
            print e
        end
      end
      ws.on :message do |event|
        begin
            p(event.data)
        rescue => e
            print e
        end
      end
      ws.on :close do |event|
        begin
            url = @client_urls.delete(ws)
            @url_clients[url].delete(ws)
            ws = nil
        rescue => e
            print e
        end
      end

      ws.rack_response
    else
      @app.call(env)
    end
  end
end
