
class AppointmentsController < ApplicationController
  # Only logged-in customers can book appointments.
  before_action :authenticate_user!
  before_action :require_customer!

  before_action :set_salon, only: [ :new, :create ]
  before_action :set_appointment, only: [ :show, :cancel ]

  # Show the current customer's appointments.
  def index
    @appointments = current_user.appointments.includes(:salon, :service).order(appointment_at: :desc)
  end

  # Display the booking form.
  def new
    @appointment = current_user.appointments.build
    @services = @salon.services.where(active: true).order(:name)
  end

  # Save a new appointment.
  def create
    @appointment = current_user.appointments.build(appointment_params)
    @appointment.salon = @salon
    @appointment.status = "pending"
    @services = @salon.services.where(active: true).order(:name)

    unless @appointment.service && @appointment.service.salon_id == @salon.id && @appointment.service.active?
      @appointment.errors.add(:service, "is not available at this salon")
      render :new, status: :unprocessable_entity
      return
    end

    if @appointment.save
      redirect_to appointments_path, notice: "Appointment booked successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Display one of the current customer's appointments.
  def show
  end

  # Allow customers to cancel their own pending appointments.
  def cancel
    unless @appointment.status == "pending"
      redirect_to appointments_path, alert: "Only pending appointments can be cancelled."
      return
    end

    @appointment.update!(status: "cancelled")

    redirect_to appointments_path, notice: "Appointment cancelled successfully."
  end

  private

  def require_customer!
    return if current_user.customer?

    redirect_to root_path, alert: "Only customers can book appointments."
  end

  def set_salon
    @salon = Salon.find(params[:salon_id])
  end

  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:service_id, :appointment_at, :notes)
  end
end
