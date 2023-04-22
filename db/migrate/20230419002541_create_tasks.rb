class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.string :title, null: false, default: ""
      t.string :date, null: false, default: ""
      t.string :time, null: false, default: ""
      t.string :location, null: false, default: ""
      t.string :status, null: false, default: "Incomplete"
      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
