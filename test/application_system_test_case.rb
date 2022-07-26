require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DOWNLOAD_PATH = Rails.root.join("tmp/downloads").to_s

  Capybara.register_driver :chrome_driver do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference('download.default_directory', DOWNLOAD_PATH)
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :options => options)
  end

  driven_by :chrome_driver, using: :chrome, screen_size: [1400, 1400]
end
