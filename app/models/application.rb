class Application < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  validates :company_name, presence: true
  validates :job_title, presence: true
end
