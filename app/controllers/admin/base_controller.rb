module Admin
  # Base controller for all admin-only pages.
  class BaseController < ApplicationController
    # Require a signed-in administrator.
    before_action :authenticate_user!
    before_action :require_admin!
  end
end
