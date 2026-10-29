# Customize Devise registration to accept the user's name and phone.
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]

  protected

  # Allow name and phone when a new user registers.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone ])
  end
end
