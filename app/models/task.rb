class Task < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  validates :title, presence: true

  validates :status, inclusion: {
    in: ["Incomplete", "In progress", "Done"],
    message: "must be one of the following: Incomplete, In progress or Done"
  }

  validate :valid_date_format?
  validate :valid_time_format?

  scope :incomplete_tasks, ->(user) { where(status: "Incomplete", user_id: user.id) }
  scope :in_progress_tasks, ->(user) { where(status: "In progress", user_id: user.id) }
  scope :completed_tasks, ->(user) { where(status: "Done", user_id: user.id) }

  def self.tasks_with_appointments(user)
    user.tasks.select { |task| task.status == "Incomplete" && !task.date.empty? && !task.time.empty? }
  end

  private

  def valid_time_format?
    time = self.time.split("")
    check_time_length(time)
    check_for_colon(time)
    check_time_for_numbers(time)
    check_for_am_or_pm(time)
  end

  def time_format_error_message
    "must follow one of two formats, X:XX or XX:XX, with X being a number, followed by am or pm."
  end

  def check_for_am_or_pm(time)
    last_two_chars = "#{time[time.length - 2]}#{time.last}"
    errors.add(:time, time_format_error_message) if !%w[am pm].include?(last_two_chars) && time.length.positive?
  end

  def check_time_for_numbers(time)
    time.each_with_index do |char, index|
      unless char.match?(/[[:digit:]]/)
        errors.add(:time, time_format_error_message) if time.length == 6 && ![1, 4, 5].include?(index)
        errors.add(:time, time_format_error_message) if time.length == 7 && ![2, 5, 6].include?(index)
      end
    end
  end

  def check_for_colon(time)
    errors.add(:time, time_format_error_message) if time.length == 6 && time[1] != ":"
    errors.add(:time, time_format_error_message) if time.length == 7 && time[2] != ":"
  end

  def check_time_length(time)
    errors.add(:time, time_format_error_message) unless [0, 6, 7].include?(time.length)
  end

  def valid_date_format?
    date = self.date.split("")
    return if date.empty?

    check_date_length(date)
    check_for_slashes(date)
    check_date_for_numbers(date)
  end

  def date_format_error_message
    "must have the following format, XX/XX/XXXX with X being a number."
  end

  def check_date_for_numbers(date)
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
