# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    association :user
    provider { Factory.next(:provider) }
    uid { Factory.next(:uid) }
  end
end