class Task < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  validates :title, presence: true
  validates :status, inclusion: {
    in: ["Incomplete", "In progress", "Done"],
    message: "must be one of the following: Incomplete, In progress or Done"
  }
  scope :completed_tasks, ->(user) { where(status: "Done", user_id: user.id) }
end
