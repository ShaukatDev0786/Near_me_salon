class AddEmailToStaffMembers < ActiveRecord::Migration[8.1]
  def change
    add_column :staff_members, :email, :string
  end
end
