class RespaceUrl
    def initialize(app, options = {})
        @app = app
    end

    def call(env)
        env['PATH_INFO'] = env['PATH_INFO'].gsub('%C2%A0','%20')
        @app.call(env)
    end
end
