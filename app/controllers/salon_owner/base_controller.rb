module SalonOwner
  # Base controller for salon-owner pages.
  class BaseController < ApplicationController
    # Require a signed-in salon owner.
    before_action :authenticate_user!
    before_action :require_salon_owner!
  end
end
