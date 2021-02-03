FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.com"}
    password {'example'}
    password_confirmation {'example'}
  end
end
