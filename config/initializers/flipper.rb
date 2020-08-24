require 'flipper'
require 'flipper/adapters/active_record'

# ADD NEW FEATURES TO THE ARRAY BELOW

features = [
  'assignments' 
]

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::ActiveRecord.new

    # pass adapter to handy DSL instance
    Flipper.new(adapter)
  end
end

Flipper::UI.configure do |config|
  config.fun = false
  config.banner_text = "Rails.env=#{Rails.env}"
  config.banner_class = 'danger'
end

# This setup is primarily for first deployment, because consequently 
# we can add new features from the Web UI. However when the DB is changed/crashed
# or in dev mode. This will immediately migrate the default features to be controlled. 
def setup_features(features)
  features.each do |feature|
    if Flipper[feature].exist?
      return
    end
    
    # Disable feature by default
    Flipper[feature].disable
  end
end

if ActiveRecord::Base.connection.data_source_exists? 'flipper_features'
  setup_features(features)
end

# Register all course names as groups

Course.all_course_names.each do |course_name|
  Flipper.register(course_name) do |actor|
    actor.respond_to?(:enrolled_in?) && actor.enrolled_in?(course_name)
  end
end