class Application < ApplicationRecord
  belongs_to :candidate
  belongs_to :job

  # curriculum_vitae
  has_one_attached :curriculum_vitae

  
end
