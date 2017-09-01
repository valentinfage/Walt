  SmsFactor::Init.configure do |config|
  config.api_url          = 'http://api.smsfactor.com'
  config.api_login        = ENV.fetch('SMS_FACTOR_LOGIN')
  config.api_password     = ENV.fetch('SMS_FACTOR_PASSWORD')
  config.api_default_from = 'Walt' #nom de l'expediteur
  end

