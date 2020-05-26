CarrierWave.configure do |config|
  #config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     'AKIAJNURU3YPPX7JTHGA',                        # required
      aws_secret_access_key: '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',                        # required
      region:                'sa-east-1',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'woodoffice'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end