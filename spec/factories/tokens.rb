# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
      token_type_id 1
      person_id 1
      cost "9.99"
      start_at "2011-09-03 15:22:55"
      stop_at "2011-09-03 15:22:55"
      used false
      motivation_id 1
      checkin_owner_id 1
      token_owner_id 1
    end
end