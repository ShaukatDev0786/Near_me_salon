# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_01_081947) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointment_services", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.bigint "service_id", null: false
    t.decimal "price", precision: 12, scale: 2, null: false
    t.integer "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id", "service_id"], name: "index_appointment_services_on_appointment_and_service", unique: true
    t.index ["appointment_id"], name: "index_appointment_services_on_appointment_id"
    t.index ["service_id"], name: "index_appointment_services_on_service_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "salon_id", null: false
    t.bigint "service_id", null: false
    t.datetime "appointment_at", null: false
    t.string "status", default: "pending", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "approval_status", default: "approved", null: false
    t.string "attendance_status", default: "not_marked", null: false
    t.string "payment_status", default: "unpaid", null: false
    t.string "payment_method"
    t.datetime "paid_at"
    t.datetime "admin_reviewed_at"
    t.text "admin_notes"
    t.index ["approval_status"], name: "index_appointments_on_approval_status"
    t.index ["attendance_status"], name: "index_appointments_on_attendance_status"
    t.index ["payment_status"], name: "index_appointments_on_payment_status"
    t.index ["salon_id"], name: "index_appointments_on_salon_id"
    t.index ["service_id"], name: "index_appointments_on_service_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "salon_id", null: false
    t.bigint "appointment_id", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_reviews_on_appointment_id"
    t.index ["salon_id"], name: "index_reviews_on_salon_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "salons", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "description"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "pincode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "approval_status", default: "pending", null: false
    t.index ["approval_status"], name: "index_salons_on_approval_status"
    t.index ["user_id"], name: "index_salons_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "salon_id", null: false
    t.string "name", null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "duration", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["salon_id"], name: "index_services_on_salon_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "phone"
    t.string "role", default: "customer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointment_services", "appointments"
  add_foreign_key "appointment_services", "services"
  add_foreign_key "appointments", "salons"
  add_foreign_key "appointments", "services"
  add_foreign_key "appointments", "users"
  add_foreign_key "reviews", "appointments"
  add_foreign_key "reviews", "salons"
  add_foreign_key "reviews", "users"
  add_foreign_key "salons", "users"
  add_foreign_key "services", "salons"
end
