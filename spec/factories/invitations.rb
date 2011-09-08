# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do |f|
    f.association :follower, :factory => :user 
    f.association :followed, :factory => :user
    end
end