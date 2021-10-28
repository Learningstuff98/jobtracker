class Application < ApplicationRecord
  belongs_to :user

  validates :company_name, presence: true
  validates :job_title, presence: true
end
