class Job < ApplicationRecord
  belongs_to :recruiter

  # validations
  validates :title, presence: true, if: -> { new_record? || title.present? }
  validates :description, presence: true, if: -> { new_record? || description.present? }
  validates :recruiter_id, presence: true
  
end
