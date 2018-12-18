require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.addArguments("--no-sandbox");
options.addArguments("--disable-dev-shm-usage");
driver = Selenium::WebDriver.for :chrome, options: options

Given(/^We navigate to the homepage$/) do
  driver.navigate.to ENV['APP_URL']
end

When(/^We search for the title The Game Of Life$/) do
  driver.title.include? 'The Game Of Life'
  puts driver.title
end

Then(/^The title for the homepage will be displayed$/) do
  # resize the window and take a screenshot
  driver.manage.window.resize_to(800, 800)
  driver.save_screenshot "screenshot.png"
  driver.quit
end
