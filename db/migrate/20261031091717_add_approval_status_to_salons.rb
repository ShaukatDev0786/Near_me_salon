class AddApprovalStatusToSalons < ActiveRecord::Migration[8.1]
  def change
    add_column :salons, :approval_status, :string, default: "pending", null: false

    add_index :salons, :approval_status
  end
end
