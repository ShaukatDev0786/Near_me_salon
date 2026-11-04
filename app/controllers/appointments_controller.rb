
class AppointmentsController < ApplicationController
  # Only logged-in customers can book appointments.
  before_action :authenticate_user!
  before_action :require_customer!

  before_action :set_salon, only: [ :new, :create ]
  before_action :ensure_salon_approved!, only: [ :new, :create ]
  before_action :set_appointment, only: [ :show, :cancel ]

  # Show the current customer's appointments.
  def index
    @appointments = current_user.appointments
      .includes(:salon, :service)
      .order(appointment_at: :desc)
  end

  # Display the booking form.
  def new
    @appointment = current_user.appointments.build
    @services = @salon.services.where(active: true).order(:name)

    selected_ids = Array(params[:service_ids]).reject(&:blank?).map(&:to_s).uniq
    selected_ids = [ params[:service_id].to_s ] if selected_ids.empty? && params[:service_id].present?

    @selected_services = @services.where(id: selected_ids)
  end

  # Save a new appointment.
  def create
    @services = @salon.services.where(active: true).order(:name)

    selected_ids = Array(params[:service_ids]).reject(&:blank?).map(&:to_s).uniq

    if selected_ids.empty? && params.dig(:appointment, :service_id).present?
      selected_ids = [ params.dig(:appointment, :service_id).to_s ]
    end

    @selected_services = @services.where(id: selected_ids)

    @appointment = current_user.appointments.build(appointment_params)
    @appointment.salon = @salon
    @appointment.status = "pending"

    unless selected_ids.any? && @selected_services.size == selected_ids.size
      @appointment.errors.add(:service, "selection is invalid or unavailable")
      render :new, status: :unprocessable_entity
      return
    end

    unless @selected_services.all? { |service| service.active? && service.salon_id == @salon.id }
      @appointment.errors.add(:service, "must be active and belong to this salon")
      render :new, status: :unprocessable_entity
      return
    end

    @appointment.service = @selected_services.first

    total_duration = @selected_services.sum { |service| service.duration.to_i }

    if @appointment.appointment_at.blank? || @appointment.appointment_at <= Time.current
      @appointment.errors.add(:appointment_at, "must be in the future")
      render :new, status: :unprocessable_entity
      return
    end

    assigned = false

    begin
      Appointment.transaction do
        @salon.staff_members.where(active: true).order(:id).each do |staff|
          staff.with_lock do
            next unless staff.available_for?(
              @appointment.appointment_at,
              total_duration
            )

            @appointment.staff_member = staff
            @appointment.save!

            @selected_services.each do |service|
              @appointment.appointment_services.create!(
                service: service,
                price: service.price,
                duration: service.duration
              )
            end

            assigned = true
          end

          break if assigned
        end

        raise ActiveRecord::Rollback unless assigned
      end
    rescue ActiveRecord::RecordInvalid => e
      @appointment.errors.add(
        :base,
        e.record.errors.full_messages.join(", ")
      )
      render :new, status: :unprocessable_entity
      return
    end

    unless assigned
      @appointment.errors.add(
        :appointment_at,
        "has no available staff member at this time. Please choose another time."
      )
      render :new, status: :unprocessable_entity
      return
    end
    AppointmentMailer.booking_confirmation(@appointment).deliver_later
    redirect_to appointments_path, notice: "Appointment booked successfully."
  end

  # Display one of the current customer's appointments.
  def show
  end

  # Allow customers to cancel their own pending appointments.
  def cancel
    unless @appointment.status == "pending"
      redirect_to appointments_path,
        alert: "Only pending appointments can be cancelled."
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

  # Prevent booking at salons that are not approved by an admin.
  def ensure_salon_approved!
    return if @salon.approval_status == "approved"

    redirect_to root_path,
      alert: "This salon is not currently available for appointments."
  end

  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:service_id, :appointment_at, :notes)
  end
end
