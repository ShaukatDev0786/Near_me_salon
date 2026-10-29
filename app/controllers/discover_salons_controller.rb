class DiscoverSalonsController < ApplicationController
  # Customers can discover salons without logging in.
  def index
    @salons = Salon.includes(:services).order(:name)

    # Search by city, allowing partial matches.
    city = params[:city].to_s.strip
    if city.present?
      @salons = @salons.where("city ILIKE ?", "%#{city}%")
    end

    # Search by an exact PIN code.
    pincode = params[:pincode].to_s.strip
    if pincode.present?
      @salons = @salons.where(pincode: pincode)
    end
  end

  def new
    @appointment = current_user.appointments.build(service_id: params[:service_id])
    @services = @salon.services.where(active: true).order(:name)
  end

  # Show public salon details and active services.
  def show
    @salon = Salon.includes(:services).find(params[:id])
    @services = @salon.services.where(active: true).order(:name)
  end
end
