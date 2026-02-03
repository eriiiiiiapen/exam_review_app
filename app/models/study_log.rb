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

  # 要復習論点
  scope :needs_review, -> {
    where.not(understanding_level: :mastered)
         .where('studied_on < ?', 5.days.ago)
  }
end
