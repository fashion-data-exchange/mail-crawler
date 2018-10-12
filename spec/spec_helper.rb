require "bundler/setup"
require "fde/mail_crawler"
require 'pry'

require 'dotenv'

Dotenv.load('.test.env')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end

FDE::MailCrawler.configure do |config|
  config.address = ENV.fetch('MAIL_ADDRESS')
  config.port = ENV.fetch('MAIL_PORT')
  config.domain = ENV.fetch('MAIL_DOMAIN')
  config.user_name = ENV.fetch('MAIL_USER_NAME')
  config.password = ENV.fetch('MAIL_PASSWORD')
  config.enable_ssl = ENV.fetch('MAIL_ENABLE_SSL')
  config.authentication = ENV.fetch('MAIL_AUTHENTICATION')
  config.enable_starttls_auto = ENV.fetch('MAIL_ENABLE_STARTTLS_AUTO')
end

