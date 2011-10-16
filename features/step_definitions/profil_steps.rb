Given /^the following user records?$/ do |table|
  table.hashes.each do |hash|
    # puts ":email=>#{hash[:email]}"
    user = User.find_by_email(hash[:email])
    unless user
      user = Factory.build(:user,:gender=>'Mr',:email=>hash[:email],:password=>hash[:password],:password_confirmation=>hash[:password],:admin=>hash[:admin],:firstname=>hash[:firstname],:lastname=>hash[:lastname])
      puts ":email=>#{hash[:email]}" unless user.valid?
      user.save
    end
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  unless email.blank?
    visit new_user_session_path
    fill_in "user_email", :with => email
    fill_in "user_password", :with => password
    click_button('new_sessions_submit')
  end
end

When /^I visit profile for "([^\"]*)"$/ do |email|
  user = User.find_by_email!(email)
  visit user_url(user)
end
