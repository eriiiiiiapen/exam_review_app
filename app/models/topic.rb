class Topic < ApplicationRecord
  belongs_to :subject
  has_many :topic_tags, dependent: :destroy
  has_many :tags, through: :topic_tags
  has_many :study_logs, dependent: :destroy

  has_one :latest_study_log, -> { order(study_on: :desc, id: :desc) }, class_name: 'StudyLog'

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  validates :name, presence: true
end
