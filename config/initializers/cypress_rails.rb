return unless Rails.env.test?

# Sources:
#  https://github.com/testdouble/cypress-rails
#  https://github.com/testdouble/cypress-rails/blob/master/example/an_app/config/initializers/cypress_rails_initializer.rb

Rails.application.load_tasks unless defined?(Rake::Task)

CypressRails.hooks.before_server_start do
  # Add our fixtures before the resettable transaction is started
  Rake::Task["db:fixtures:load"].invoke
end

CypressRails.hooks.after_transaction_start do
  # Called after the transaction is started (at launch and after each reset)
end
  
CypressRails.hooks.after_state_reset do
  # Triggered after `/cypress_rails_reset_state` is called
end

CypressRails.hooks.before_server_stop do
  # Purge and reload the test database so we don't leave our fixtures in there
  Rake::Task["db:test:prepare"].invoke
end
