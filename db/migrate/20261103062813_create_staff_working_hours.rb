class CreateStaffWorkingHours < ActiveRecord::Migration[8.1]
  def change
    create_table :staff_working_hours do |t|
      t.references :staff_member, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :opens_at
      t.time :closes_at
      t.boolean :day_off, default: false, null: false

      t.timestamps
    end

    add_index :staff_working_hours, [ :staff_member_id, :day_of_week ], unique: true, name: "index_staff_working_hours_on_staff_and_day"
  end
end
