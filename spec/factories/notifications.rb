# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
      person_id 1
      sent_at "2011-09-03 15:39:40"
      at_who "MyText"
      content "MyText"
    end
end