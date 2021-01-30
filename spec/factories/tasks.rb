FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "書類作成#{n}" }
    content {"取引先に書類を作成する"}
    status {"todo"}
    deadline { 1.week.from_now }
    association :user
  end
end
