# frozen_string_literal: true

class SdkCacheControl
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    if env['PATH_INFO']&.start_with?('/packs/js/sdk')
      headers['Cache-Control'] = 'no-cache, must-revalidate'
      headers['Pragma'] = 'no-cache'
      headers['Expires'] = '0'
    end
    [status, headers, body]
  end
end

Rails.application.config.middleware.insert_before ActionDispatch::Static, SdkCacheControl
