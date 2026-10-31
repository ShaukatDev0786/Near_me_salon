class SalonOwner::AppointmentsController < ApplicationController
  before_action :set_appointment, only: [ :show, :confirm, :cancel, :update_attendance, :record_payment ]

  def index
    @appointments = Appointment
      .joins(:salon)
      .where(salons: { user_id: current_user.id })
      .includes(:salon, :service, :user)
      .order(appointment_at: :desc)

    # Search by customer email, salon name, or service name.
    if params[:q].present?
      search_term = "%#{Appointment.sanitize_sql_like(params[:q].strip)}%"

      @appointments = @appointments
        .joins(:user, :service)
        .where(
          "users.email ILIKE :term OR salons.name ILIKE :term OR services.name ILIKE :term",
          term: search_term
        )
    end

    # Apply filters only when the corresponding value is present.
    if Appointment::STATUSES.include?(params[:status])
      @appointments = @appointments.where(status: params[:status])
    end

    if Appointment::ATTENDANCE_STATUSES.include?(params[:attendance_status])
      @appointments = @appointments.where(attendance_status: params[:attendance_status])
    end

    if Appointment::PAYMENT_STATUSES.include?(params[:payment_status])
      @appointments = @appointments.where(payment_status: params[:payment_status])
    end

    if Appointment::APPROVAL_STATUSES.include?(params[:approval_status])
      @appointments = @appointments.where(approval_status: params[:approval_status])
    end

    if params[:date_from].present?
      begin
        @appointments = @appointments.where("appointment_at >= ?", Date.iso8601(params[:date_from]).beginning_of_day)
      rescue Date::Error
        flash.now[:alert] = "Invalid start date. Please select a valid date."
      end
    end

    if params[:date_to].present?
      begin
        @appointments = @appointments.where("appointment_at <= ?", Date.iso8601(params[:date_to]).end_of_day)
      rescue Date::Error
        flash.now[:alert] = "Invalid end date. Please select a valid date."
      end
    end

    @appointments = @appointments.page(params[:page]).per(10)

    # Dashboard counts across all appointments belonging to this owner's salons.
    owner_appointments = Appointment.joins(:salon)
      .where(salons: { user_id: current_user.id })

    @total_appointments = owner_appointments.count
    @pending_appointments = owner_appointments.where(status: "pending").count
    @today_appointments = owner_appointments.where(appointment_at: Time.zone.today.all_day).count
    @unpaid_appointments = owner_appointments.where(payment_status: "unpaid").count
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
    redirect_to salon_owner_appointments_path, notice: "Appointment cancelled successfully."
  end

  def update_attendance
    attendance = params[:attendance_status]

    unless Appointment::ATTENDANCE_STATUSES.include?(attendance) && %w[attended no_show].include?(attendance)
      redirect_to salon_owner_appointments_path,
                  alert: "Please select a valid attendance status."
      return
    end

    unless %w[confirmed completed].include?(@appointment.status)
      redirect_to salon_owner_appointments_path,
                  alert: "Only confirmed or completed appointments can have attendance recorded."
      return
    end

    if @appointment.update(attendance_status: attendance)
      redirect_to salon_owner_appointments_path,
                  notice: "Attendance updated successfully."
    else
      redirect_to salon_owner_appointments_path,
                  alert: @appointment.errors.full_messages.to_sentence
    end
  end

  def record_payment
    payment_status = params[:payment_status]
    payment_method = params[:payment_method].to_s.strip.presence

    unless %w[unpaid paid refunded].include?(payment_status)
      redirect_to salon_owner_appointments_path,
                  alert: "Please select a valid payment status."
      return
    end

    if payment_status == "paid" && payment_method.blank?
      redirect_to salon_owner_appointments_path,
                  alert: "Please select a payment method."
      return
    end

    attributes = {
      payment_status: payment_status,
      payment_method: payment_status == "paid" ? payment_method : nil,
      paid_at: payment_status == "paid" ? (@appointment.paid_at || Time.current) : nil
    }

    if @appointment.update(attributes)
      redirect_to salon_owner_appointments_path,
                  notice: "Payment details updated successfully."
    else
      redirect_to salon_owner_appointments_path,
                  alert: @appointment.errors.full_messages.to_sentence
    end
  end

  private

  def set_appointment
    @appointment = Appointment
      .joins(:salon)
      .where(salons: { user_id: current_user.id })
      .find(params[:id])
  end
end
