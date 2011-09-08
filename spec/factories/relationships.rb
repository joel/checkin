# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relationship do |f|
    f.association :follower
    f.association :followed
  end
end