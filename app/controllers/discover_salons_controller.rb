class DiscoverSalonsController < ApplicationController
  # Customers can discover approved salons without logging in.
  def index
    @salons = Salon.approved.includes(:services).order(:name)

    city = params[:city].to_s.strip
    if city.present?
      @salons = @salons.where("city ILIKE ?", "%#{city}%")
    end

    pincode = params[:pincode].to_s.strip
    if pincode.present?
      @salons = @salons.where(pincode: pincode)
    end
  end

  def show
    @salon = Salon.approved.includes(:services).find(params[:id])
    @services = @salon.services.where(active: true).order(:name)
  end
end
