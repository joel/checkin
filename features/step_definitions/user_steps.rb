Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^I have one\s+user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  Factory(:user, :email => email,
           :password => password,
           :password_confirmation => password)
end

Given /^that a confirmed user exists$/ do
  @user = Factory(:user)
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'

  Given %{I have one user "#{email}" with password "#{password}"}
  And %{I go to login}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

Then /^I should see "([^"]*)$/ do |message|
  assert page.has_content?(message)
end

# Then /^I should redirect to new person page$/ do
#   pending # express the regexp above with the code you wish you had
# end
