require 'flipper'
require 'flipper/adapters/active_record'

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::ActiveRecord.new

    # pass adapter to handy DSL instance
    Flipper.new(adapter)
  end
end

