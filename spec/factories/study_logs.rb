FactoryBot.define do
  factory :study_log do
    association :user
    association :topic
    study_on { Date.today }
    understanding_level { :not_understood }
  end
end
