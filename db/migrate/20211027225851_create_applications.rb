class CreateApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :applications do |t|
      t.integer :user_id
      t.string :company_name
      t.string :job_title
      t.boolean :tech_job
      t.boolean :remote
      t.timestamps
    end
  end
end
