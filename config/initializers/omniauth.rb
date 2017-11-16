Rails.application.config.middleware.use OmniAuth::Builder do
  # Note: when you change your environment variable, you might have to restart the application

  github_scopes = 'user:email,admin:org'
  omniauth_strategy = ENV['OMNIAUTH_STRATEGY']

  provider_url = ENV['GIT_PROVIDER_URL']
  provider_key = Rails.application.secrets.omniauth_provider_key
  provider_secret = Rails.application.secrets.omniauth_provider_secret

  case omniauth_strategy
  when 'github' # default is github
    provider :github, provider_key, provider_secret, scope: github_scopes
  when 'github_enterprise'
    provider :github, provider_key, provider_secret, scope: github_scopes,
              client_options: {
                site: "https://#{provider_url}/api/v3",
                authorize_url: "https://#{provider_url}/login/oauth/authorize",
                token_url: "https://#{provider_url}/login/oauth/access_token"
              }
  when 'gitlab' # define scopes at application registration time on gitlab site
    provider :gitlab, provider_key, provider_secret,
              client_options: {
                  site: "https://#{provider_url}",
                  authorize_url: '/oauth/authorize',
                  token_url: '/oauth/token'
              }
  else # default to github? or fail out?
    provider :github, provider_key, provider_secret, scope: github_scopes
  end
end
