class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :salon, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.datetime :appointment_at, null: false
      t.string :status, null: false, default: "pending"
      t.text :notes

      t.timestamps
    end
  end
end
