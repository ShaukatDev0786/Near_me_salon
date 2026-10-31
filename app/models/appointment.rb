class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :salon
  belongs_to :service

  STATUSES = %w[pending confirmed cancelled completed].freeze
  APPROVAL_STATUSES = %w[pending approved rejected].freeze
  ATTENDANCE_STATUSES = %w[not_marked attended no_show].freeze
  PAYMENT_STATUSES = %w[unpaid paid refunded].freeze

  validates :appointment_at, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :approval_status, inclusion: { in: APPROVAL_STATUSES }
  validates :attendance_status, inclusion: { in: ATTENDANCE_STATUSES }
  validates :payment_status, inclusion: { in: PAYMENT_STATUSES }

  validate :appointment_must_be_in_future, on: :create
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
