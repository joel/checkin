# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :motivation do
    sequence(:title) { |n| "My Motivation #{n}"}
  end
end