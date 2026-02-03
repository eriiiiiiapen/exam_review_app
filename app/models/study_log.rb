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
         .where('study_on < ?', 5.days.ago)
  }

  def understanding_level_text
    I18n.t("activerecord.attributes.study_log.understanding_levels.#{understanding_level}")
  end
end
