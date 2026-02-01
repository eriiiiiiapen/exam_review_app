class Exam < ApplicationRecord
    has_many :subjects, dependent: :destroy
end
