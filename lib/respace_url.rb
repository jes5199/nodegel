class RespaceUrl
    def initialize(app, options = {})
        @app = app
    end

    def call(env)
        env['PATH_INFO'] = RespaceUrl.unspace(env['PATH_INFO'])
        @app.call(env)
    end

    def self.unspace(url)
        url.gsub('%C2%A0','%20')
    end
end
