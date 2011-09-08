# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do |f|
    f.association :token_type
    f.association :motivation
    f.association :checkin_owner, :factory => :user
    f.association :token_owner, :factory => :user
    f.association :user
    f.cost "9.99"
    f.start_at Timecop.freeze(2.hours.ago)
    f.stop_at Timecop.freeze(2.hours.since)
    f.used false
  end
end