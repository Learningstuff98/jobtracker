class AddIndexToApplications < ActiveRecord::Migration[6.1]
  def change
    add_index :applications, :user_id
  end
end
