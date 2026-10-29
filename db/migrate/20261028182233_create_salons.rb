class CreateSalons < ActiveRecord::Migration[8.1]
  def change
    create_table :salons do |t|
      # Link each salon to its owner.
      t.references :user, null: false, foreign_key: true

      # Basic salon information.
      t.string :name
      t.text :description
      t.string :phone

      # Salon location details.
      t.string :address
      t.string :city
      t.string :pincode

      t.timestamps
    end
  end
end
