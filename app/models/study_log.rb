class StudyLog < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  enum :understanding_level, {
    not_understood: 0,
    vaguely_understood: 1,
    understood: 2,
    mastered: 3
  }, scopes: false

  validates :understanding_level, presence: true
end
