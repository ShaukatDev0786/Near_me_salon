module Admin
  class SalonsController < BaseController
    before_action :set_salon, only: [:approve, :reject]

    def index
      # Global salon counts for the summary cards
      @total_salons = Salon.count
      @pending_salons = Salon.pending_approval.count
      @approved_salons = Salon.approved.count
      @rejected_salons = Salon.where(approval_status: "rejected").count

      # Start with all salons
      @salons = Salon.includes(:user).order(created_at: :desc)

      # Filter by approval status
      if Salon::APPROVAL_STATUSES.include?(params[:approval_status])
        @salons = @salons.where(approval_status: params[:approval_status])
      end

      # Search by salon name, owner email, city, or PIN code
      search_term = params[:search].to_s.strip

      if search_term.present?
        escaped_term = ActiveRecord::Base.sanitize_sql_like(search_term)
        search_pattern = "%#{escaped_term}%"

        @salons = @salons
          .left_joins(:user)
          .where(
            "salons.name ILIKE :term OR users.email ILIKE :term OR " \
            "salons.city ILIKE :term OR salons.pincode ILIKE :term",
            term: search_pattern
          )
      end

      # Count filtered results before pagination
      @filtered_salons_count = @salons.count

      @salons = @salons.page(params[:page]).per(10)
    end

    def approve
      if @salon.update(approval_status: "approved")
        redirect_to admin_salons_path, notice: "Salon approved successfully."
      else
        redirect_to admin_salons_path,
          alert: @salon.errors.full_messages.to_sentence
      end
    end

    def reject
      if @salon.update(approval_status: "rejected")
        redirect_to admin_salons_path, notice: "Salon rejected successfully."
      else
        redirect_to admin_salons_path,
          alert: @salon.errors.full_messages.to_sentence
      end
    end

    private

    def set_salon
      @salon = Salon.find(params[:id])
    end
  end
end
