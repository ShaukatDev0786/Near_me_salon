class AddManagementFieldsToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_column :appointments, :approval_status, :string, default: "approved", null: false
    add_column :appointments, :attendance_status, :string, default: "not_marked", null: false
    add_column :appointments, :payment_status, :string, default: "unpaid", null: false
    add_column :appointments, :payment_method, :string
    add_column :appointments, :paid_at, :datetime
    add_column :appointments, :admin_reviewed_at, :datetime
    add_column :appointments, :admin_notes, :text

    add_index :appointments, :approval_status
    add_index :appointments, :attendance_status
    add_index :appointments, :payment_status
  end
end
