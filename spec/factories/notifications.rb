# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do |f|
    f.association :user, :factory => :user
    f.sent_at Time.now
    # f.at_who User.all.collect { |u| Array(u.email) }.flatten!
    # f.at_who 10.times { Array(Factory(:user).email) }.flatten!
    f.content "MyText"
  end
end