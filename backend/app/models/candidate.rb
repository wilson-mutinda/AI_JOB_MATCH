class Candidate < ApplicationRecord
  belongs_to :user

  has_many :applications

  has_one :job

  # validations
  validates :first_name, presence: true, if: -> { new_record? || first_name.present? }
  validates :last_name, presence: true, if: -> { new_record? || last_name.present? }
  validates :username, presence: true, uniqueness: true, if: -> { new_record? || username.present? }
  validates :date_of_birth, presence: true, if: -> { new_record? || date_of_birth.present? }
  
end
