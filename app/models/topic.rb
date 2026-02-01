class Topic < ApplicationRecord
  belongs_to :subject
  has_many :study_logs, dependent: :destroy
end
