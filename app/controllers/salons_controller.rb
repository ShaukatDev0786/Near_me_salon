
class SalonsController < ApplicationController
  # Only logged-in salon owners can manage salons.
  before_action :authenticate_user!
  before_action :require_salon_owner!

  # Load a salon for actions that need an existing record.
  before_action :set_salon, only: [ :show, :edit, :update, :destroy ]

  # Display only the current owner's salons.
  def index
    @salons = current_user.salons.order(created_at: :desc)
  end

  # Display the form for a new salon.
  def new
    @salon = current_user.salons.build
  end

  # Save a new salon owned by the current user.
  def create
    @salon = current_user.salons.build(salon_params)

    if @salon.save
      redirect_to @salon, notice: "Salon created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Display one of the current owner's salons.
  def show
  end

  # Display the edit form.
  def edit
  end

  # Update the current owner's salon.
  def update
    if @salon.update(salon_params)
      redirect_to @salon, notice: "Salon updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete the current owner's salon.
  def destroy
    @salon.destroy
    redirect_to salons_path, notice: "Salon deleted successfully."
  end

  private

  # Restrict salon management to salon owners.
  def require_salon_owner!
    return if current_user.salon_owner?

    redirect_to root_path, alert: "You are not authorized to manage salons."
  end

  # Find the salon only among the current owner's salons.
  # This prevents owners from accessing another owner's salon by changing its ID.
  def set_salon
    @salon = current_user.salons.find(params[:id])
  end

  # Permit only fields that salon owners are allowed to edit.
  def salon_params
    params.require(:salon).permit(
      :name,
      :description,
      :phone,
      :address,
      :city,
      :pincode
    )
  end
end
