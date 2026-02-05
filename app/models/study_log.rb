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

  def self.next_level_for(current_level)
    levels = understanding_levels.keys
    current_index = levels.index(current_level.to_s) || -1
    next_index = current_index + 1

    next_index = 0 if next_index >= levels.size
    levels[next_index]
  end
end
