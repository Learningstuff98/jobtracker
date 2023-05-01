class Task < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  validates :title, presence: true

  validates :status, inclusion: {
    in: ["Incomplete", "In progress", "Done"],
    message: "must be one of the following: Incomplete, In progress or Done"
  }

  validate :valid_date_format?

  scope :incomplete_tasks, ->(user) { where(status: "Incomplete", user_id: user.id) }
  scope :in_progress_tasks, ->(user) { where(status: "In progress", user_id: user.id) }
  scope :completed_tasks, ->(user) { where(status: "Done", user_id: user.id) }

  private

  def valid_date_format?
    date = self.date.split("")
    return if date.empty?

    check_date_length(date)
    check_for_slashes(date)
    check_for_numbers(date)
  end

  def date_format_error_message
    "must have the following format, XX/XX/XXXX with X being a number."
  end

  def check_for_numbers(date)
    date.each_with_index do |char, index|
      errors.add(:date, date_format_error_message) if ![2, 5].include?(index) && !char.match?(/[[:digit:]]/)
    end
  end

  def check_date_length(date)
    errors.add(:date, date_format_error_message) if date.length != 10
  end

  def check_for_slashes(date)
    errors.add(:date, date_format_error_message) if date[2] != "/" || date[5] != "/"
  end
end
