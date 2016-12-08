Given(/^that user "([^"]*)" with password "([^"]*)" has logged in$/) do |login, password|
  visit('/session/new')
  fill_in('login-input', with: login)
  fill_in('password', with: password)
  click_button('login_submit_button')
  expect(page).to have_content("Welcome, Chris!")
end

When(/^the admin user broadcasts "([^"]*)" to the notification feed$/) do |message|
  visit('/broadcasts/new')
  fill_in('new_broadcast_text_area', with: message)
  check('feeds[notification_feed]')
  click_button('new_broadcast_submit_button')
end

Then(/^the current page should contain the text: "([^"]*)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^the current page should show the text "([^"]*)" in the notification feed$/) do |message|
  assert_selector('#notification_feed_table', text: message)
end