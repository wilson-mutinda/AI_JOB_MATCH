class User < ApplicationRecord

  has_one :recruiter

  has_one :candidate

  # secure_password
  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :flag, presence: true
  validates :password, presence: true, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }
end
