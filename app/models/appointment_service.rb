class AppointmentService < ApplicationRecord
  belongs_to :appointment
  belongs_to :service

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validates :service_id, uniqueness: { scope: :appointment_id }
end
