require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DOWNLOAD_PATH = Rails.root.join("tmp/downloads").to_s

  Capybara.register_driver :chrome_driver do |app|
    profile = Selenium::WebDriver::Chrome::Profile.new
    profile["download.default_directory"] = DOWNLOAD_PATH
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
  end

  Capybara.default_driver = Capybara.javascript_driver = :chrome

  driven_by :chrome_driver, using: :chrome, screen_size: [1400, 1400]
end
