
class ServicesController < ApplicationController
  # Only logged-in salon owners can manage services.
  before_action :authenticate_user!
  before_action :require_salon_owner!

  # Find the salon and service for actions that need an existing record.
  before_action :set_salon
  before_action :set_service, only: [ :edit, :update, :destroy ]

  # List services belonging to the selected salon.
  def index
    @services = @salon.services.order(created_at: :desc)
  end

  # Display the form for a new service.
  def new
    @service = @salon.services.build
  end

  # Save a new service.
  def create
    @service = @salon.services.build(service_params)

    if @service.save
      redirect_to salon_services_path(@salon), notice: "Service created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Display the edit form.
  def edit
  end

  # Update an existing service.
  def update
    if @service.update(service_params)
      redirect_to salon_services_path(@salon), notice: "Service updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete a service.
  def destroy
    @service.destroy

    redirect_to salon_services_path(@salon), notice: "Service deleted successfully."
  end

  private

  # Owners can only access their own salons.
  def set_salon
    @salon = current_user.salons.find(params[:salon_id])
  end

  # Services must belong to the selected salon.
  def set_service
    @service = @salon.services.find(params[:id])
  end

  # Permit only fields the owner is allowed to edit.
  def service_params
    params.require(:service).permit(
      :name,
      :description,
      :price,
      :duration,
      :active
    )
  end

  def require_salon_owner!
    return if current_user.salon_owner?

    redirect_to root_path, alert: "You are not authorized to manage services."
  end
end
