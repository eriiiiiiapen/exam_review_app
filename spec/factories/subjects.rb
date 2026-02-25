FactoryBot.define do
  factory :subject do
    name { "労働基準法" }
    association :exam
  end
end
