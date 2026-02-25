require "csv"

class Topic < ApplicationRecord
  belongs_to :subject
  has_many :topic_tags, dependent: :destroy
  has_many :tags, through: :topic_tags
  has_many :study_logs, dependent: :destroy

  has_one :latest_study_log, -> { order(study_on: :desc, id: :desc) }, class_name: "StudyLog"

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  validates :name, presence: true

  def self.import_csv!(file)
    subjects_cache = Subject.pluck(:name, :id).to_h

    CSV.foreach(file.path, headers: true) do |row|
      ActiveRecord::Base.transaction do
        subject_id = subjects_cache[row["科目"]]
        unless subject_id
          exam = Exam.first
          new_subject = Subject.find_or_create_by!(name: row["科目"], exam: exam)
          subject_id = new_subject.id
          subjects_cache[row["科目"]] = subject_id
        end

        topic = Topic.find_or_initialize_by(name: row["論点名"], subject_id: subject_id)
        topic.description = row["説明"]
        topic.save!

        if row["タグ"].present?
          tag_names = row["タグ"].split(":").map(&:strip)
          tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }
          topic.tags = tags
        end
      end
    end
  end

  def study_status(user)
    user_logs = study_logs.select { |l| l.user_id == user.id }
    return :new if user_logs.empty?

    total = user_logs.sum { |l| l.understanding_level.to_f }
    avg = total / user_logs.size
    avg < 2.0 ? :weak : :learned
  end
end
