class StaffAppointmentReminderJob < ApplicationJob
  queue_as :default

  def perform(appointment_id, staff_member_id)
    appointment = Appointment.find_by(id: appointment_id)

    return unless appointment
    return unless appointment.status == "confirmed"
    return unless appointment.staff_member_id == staff_member_id
    return if appointment.appointment_at <= Time.current

    staff_member = appointment.staff_member

    return unless staff_member&.active?
    return if staff_member.email.blank?

    AppointmentMailer.staff_appointment_reminder(appointment).deliver_now
  end
end
