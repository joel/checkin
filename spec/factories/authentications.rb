# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
      user_id 1
      provider "MyString"
      uid "MyString"
    end
end