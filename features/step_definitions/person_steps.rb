# Given /^I am on the new person page after set user:$/ do
#   user = Factory(:user)
#   person = Factory(:person,:user=>user)
#   sign_in :user, user
# end

Given /^I am logged in$/ do
  # @user = Factory(:user)
  visit path_to('the login page')
  fill_in('user_email', :with => @user.email)
  fill_in('user_password', :with => @user.password)
  click_button('new_sessions_submit')
  # assert page.has_content?('Signed in successfully.')
end

Given /^the following people:$/ do |people|
  User.create!(people.hashes)
end
