class CreateStaffMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :staff_members do |t|
      t.references :salon, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
