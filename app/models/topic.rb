class Topic < ApplicationRecord
  belongs_to :subject
  has_many :study_logs, dependent: :destroy

  has_one :latest_study_log, -> { order(study_on: :desc, id: :desc) }, class_name: 'StudyLog'
end
