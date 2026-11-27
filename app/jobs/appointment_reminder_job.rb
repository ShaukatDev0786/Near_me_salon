class AppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform(appointment_id)
    appointment = Appointment.find_by(id: appointment_id)

    return unless appointment
    return unless appointment.status == "confirmed"
    return if appointment.appointment_at <= Time.current

    AppointmentMailer.appointment_reminder(appointment).deliver_now
  end
end
