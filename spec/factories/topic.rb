FactoryBot.define do
  factory :topic do
    name { "論点" }
    description { "概要" }
    association :subject
  end
end
