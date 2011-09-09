Given /^This following motivations records$/ do |table|
  table.hashes.each do |hash|
    Factory(:motivation,:title=>hash[:title])
  end
end

When /^I visit page of "([^"]*)" for checkin$/ do |email|
  user = User.find_by_email!(email)
  visit new_user_check_url(user)
end

Given /^Some credits for "([^"]*)" by "([^"]*)"$/ do |email, token_owner|
  user = User.find_by_email!(email)
  full_day = Factory(:token_type,:title=>'full day')
  half_day = Factory(:token_type,:title=>'half day')
  token_owner = (token_owner == "john doe") ? nil : User.find_by_email!(token_owner)
  5.times { Factory(:token,:token_type=>full_day,:user=>user,:token_owner=>token_owner,:checkin_owner=>nil) }
  5.times { Factory(:token,:token_type=>half_day,:user=>user,:token_owner=>token_owner,:checkin_owner=>nil) }
end

When /^I checkin for "([^"]*)" with "([^"]*)" and "([^"]*)" by "([^"]*)" for "([^"]*)"$/ do |email, token_type, motivation, checkin_owner, day|
  day = day ? day.to_i : 0
  user = User.find_by_email!(email)
  motivation_id = Motivation.find_by_title(motivation).id
  token_type_id = TokenType.find_by_title(token_type).id
  checkin_owner_id = checkin_owner == "john doe" ? nil : User.find_by_email!(checkin_owner).id
  Timecop.freeze(Time.now.advance(:days => +day)) do
    user.checkin(token_type_id, motivation_id, checkin_owner_id)
  end
end
