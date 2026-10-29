# Dashboard available only to signed-in customers.
class Customer::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_customer!

  def index
  end

  private

  # Prevent salon owners and admins from accessing the customer dashboard.
  def require_customer!
    return if current_user.customer?

    redirect_to root_path, alert: "You are not authorized to access this page."
  end
end
