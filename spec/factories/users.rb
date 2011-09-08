# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "foo#{n}@bar.com" }
    f.password 'foobarzone'
    f.password_confirmation 'foobarzone'
    f.firstname "Korben"
    f.lastname "DALLAS"
    f.gender "Mr"
    f.company "The World Company"
    f.phone "0678543492"
    f.admin false
  end
end