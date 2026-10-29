class SalonOwner::AppointmentsController < ApplicationController
  before_action :set_appointment, only: [ :show, :confirm, :cancel ]

  def index
    # Only show appointments for salons owned by the logged-in owner.
    @appointments = Appointment.joins(:salon).where(salons: { user_id: current_user.id }).includes(:salon, :service, :user).order(appointment_at: :asc)
  end

  def show
  end

  def confirm
    unless @appointment.status == "pending"
      redirect_to salon_owner_appointments_path, alert: "Only pending appointments can be confirmed."
      return
    end

    @appointment.update!(status: "confirmed")

    redirect_to salon_owner_appointments_path, notice: "Appointment confirmed successfully."
  end

  def cancel
    unless %w[pending confirmed].include?(@appointment.status)
      redirect_to salon_owner_appointments_path, alert: "This appointment cannot be cancelled."
      return
    end

    @appointment.update!(status: "cancelled")

    redirect_to salon_owner_appointments_path,  notice: "Appointment cancelled successfully."
  end

  private

  def set_appointment
    # Restrict access to appointments belonging to the owner's salons.
    @appointment = Appointment.joins(:salon).where(salons: { user_id: current_user.id }).find(params[:id])
  end
end
