# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token_type do
    sequence(:title) { |n| "Token Type #{n}"}
  end
end