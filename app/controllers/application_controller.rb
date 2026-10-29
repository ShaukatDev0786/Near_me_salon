class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Allow only the permitted fields during Devise registration.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Users can register with their name and phone.
    # The public registration form cannot set the user's role.
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone ])
  end

  # Check whether the current user is an administrator.
  def require_admin!
    return if current_user&.admin?

    redirect_to root_path, alert: "You are not authorized to access this page."
  end

  # Check whether the current user is a salon owner.
  def require_salon_owner!
    return if current_user&.salon_owner?

    redirect_to root_path, alert: "You are not authorized to access this page."
  end
end
