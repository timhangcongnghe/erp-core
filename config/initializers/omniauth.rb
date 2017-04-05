Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1857760154495631', 'ec906caa081b1f8d1dabcf6929aa4d3b'
end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '657007310944-qjeidk1hhg57mli8fdv5mnbqrnrdf9h5.apps.googleusercontent.com', '0oUO69fjgXjjJ3hPgXqc61OA'
end
# Added to config/initializers/omniauth.rb
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
