Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Settings.github_id, Settings.github_secret, scope: "user:email"
end
