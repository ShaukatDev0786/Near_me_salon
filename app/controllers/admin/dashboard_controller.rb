
module Admin
  class DashboardController < BaseController
    def index
      # User statistics
      @total_users = User.count
      @total_customers = User.where(role: "customer").count
      @total_salon_owners = User.where(role: "salon_owner").count
      @total_admins = User.where(role: "admin").count

      # Salon statistics
      @total_salons = Salon.count
      @pending_salons = Salon.pending_approval.count
      @approved_salons = Salon.approved.count
      @rejected_salons = Salon.where(approval_status: "rejected").count

      # Service statistics
      @total_services = Service.count

      # Appointment statistics
      @total_appointments = Appointment.count
      @pending_appointments = Appointment.where(status: "pending").count
      @confirmed_appointments = Appointment.where(status: "confirmed").count
      @cancelled_appointments = Appointment.where(status: "cancelled").count
      @completed_appointments = Appointment.where(status: "completed").count

      # Appointments scheduled for today
      @appointments_today = Appointment.where(
        appointment_at: Date.current.all_day
      ).count

      # Latest appointments
      @recent_appointments = Appointment
        .includes(:user, :salon, :service)
        .order(created_at: :desc)
        .limit(5)
    end
  end
end
