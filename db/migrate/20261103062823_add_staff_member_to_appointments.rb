class AddStaffMemberToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_reference :appointments, :staff_member, null: true, foreign_key: true, index: true
  end
end
