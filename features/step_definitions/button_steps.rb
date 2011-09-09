# Given /^This following person records with credits$/ do |table|
#   table.hashes.each do |hash|
#     user = Factory(:user,:email=>hash[:email],:password=>hash[:password],:password_confirmation=>hash[:password])
#     person = Factory(:person,:user=>user,:firstname=>hash[:name])
#     full_day = Factory(:token_type,:title=>'full day')
#     8.times { Factory(:token,:token_type=>full_day,:person=>person,:token_owner=>nil,:checkin_owner=>nil) }
#   end
# end

Given /^This following person records$/ do |table|
  table.hashes.each do |hash|
    user = Factory(:user,:email=>hash[:email],:password=>hash[:password],:password_confirmation=>hash[:password],:firstname=>hash[:name])
  end
end

When /^I invit "([^"]*)" person$/ do |email|
  visit people_url
  click_button "request_an_invitation_for_#{User.find_by_email(email).id}"
end

Given /^An invit from "([^"]*)" to "([^"]*)"$/ do |follower_email, followed_email|
  follower = User.find_by_email(follower_email)
  followed = User.find_by_email(followed_email)
  Factory(:invitation, :follower => follower, :followed => followed)
end

When /^I accept "([^"]*)" invitation$/ do |followed_email|
  followed = User.find_by_email(followed_email)
  followed.invitations.first.accept!
end
