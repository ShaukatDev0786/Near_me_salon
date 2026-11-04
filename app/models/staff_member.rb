class StaffMember < ApplicationRecord
  belongs_to :salon

  has_many :staff_working_hours, dependent: :destroy
  has_many :appointments, dependent: :nullify

  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }

  def available_for?(start_time, duration_minutes)
    return false unless active?
    return false if start_time.blank? || duration_minutes.to_i <= 0

    end_time = start_time + duration_minutes.to_i.minutes

    working_hour = staff_working_hours.find_by(day_of_week: start_time.wday)

    return false if working_hour.nil? || working_hour.day_off?
    return false if working_hour.opens_at.nil? || working_hour.closes_at.nil?

    opening_time = start_time.change(
      hour: working_hour.opens_at.hour,
      min: working_hour.opens_at.min,
      sec: 0
    )

    closing_time = start_time.change(
      hour: working_hour.closes_at.hour,
      min: working_hour.closes_at.min,
      sec: 0
    )

    # The appointment must start during working hours.
    # It is allowed to finish after closing time.
    return false if start_time < opening_time || start_time >= closing_time

    overlapping_appointment = appointments
      .where.not(status: "cancelled")
      .where(
        <<~SQL.squish,
          appointment_at < ?
          AND appointment_at + INTERVAL '1 minute' * COALESCE(
            (
              SELECT SUM(appointment_services.duration)
              FROM appointment_services
              WHERE appointment_services.appointment_id = appointments.id
            ),
            (
              SELECT services.duration
              FROM services
              WHERE services.id = appointments.service_id
            )
          ) > ?
        SQL
        end_time,
        start_time
      )
      .exists?

    !overlapping_appointment
  end
end
