class AppointmentMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.appointment_mailer.booking_confirmation.subject
  #
   def booking_confirmation(appointment)
    @appointment = appointment
    @customer = appointment.user
    @salon = appointment.salon

    mail(
      to: @customer.email,
      subject: "Booking Confirmation - NearMe Salon"
    )
  end

  def appointment_approved(appointment)
    @appointment = appointment
    @customer = appointment.user
    @salon = appointment.salon

    mail(
      to: @customer.email,
      subject: "Your Appointment Has Been Confirmed - NearMe Salon"
    )
  end

  def appointment_cancelled(appointment)
    @appointment = appointment
    @customer = appointment.user
    @salon = appointment.salon

    mail(
      to: @customer.email,
      subject: "Appointment Cancelled - NearMe Salon"
    )
  end

  def appointment_reminder(appointment)
    @appointment = appointment
    @customer = appointment.user
    @salon = appointment.salon

    mail(
      to: @customer.email,
      subject: "Appointment Reminder - NearMe Salon"
    )
  end

  def staff_appointment_reminder(appointment)
    @appointment = appointment
    @customer = appointment.user
    @salon = appointment.salon
    @staff_member = appointment.staff_member

    mail(
      to: @staff_member.email,
      subject: "Upcoming Appointment Reminder - NearMe Salon"
    )
  end
end
