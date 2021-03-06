class AdminMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    if request.path.start_with?("/admin/")
      auth = Rack::Auth::Basic.new(@app) do |u, p|
        u == username && p == password
      end

      auth.call env
    else
      @app.call env
    end
  end

  private

  def username
    Rails.application.credentials.admin_username
  end

  def password
    Rails.application.credentials.admin_password
  end
end
