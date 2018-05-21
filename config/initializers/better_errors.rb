if Rails.env.development? && defined?(BetterErrors) && defined?(DOCKER_IP)
  BetterErrors::Middleware.allow_ip! DOCKER_IP
end
