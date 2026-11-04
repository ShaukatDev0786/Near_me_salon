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
end
