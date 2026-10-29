class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :salon
  belongs_to :service

  STATUSES = %w[pending confirmed cancelled completed].freeze

  validates :appointment_at, presence: true
  validates :status, inclusion: { in: STATUSES }

  validate :appointment_must_be_in_future
  validate :service_must_belong_to_salon

  private

  def appointment_must_be_in_future
    return if appointment_at.blank?
    return if appointment_at > Time.current

    errors.add(:appointment_at, "must be in the future")
  end

  def service_must_belong_to_salon
    return if service.blank? || salon.blank?
    return if service.salon_id == salon_id

    errors.add(:service, "must belong to the selected salon")
  end
end
