# Dashboard available only to salon owners.
class SalonOwner::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_salon_owner!

  def index
  end
end
