class User < ApplicationRecord
  # Devise manages login, registration, password recovery, and sessions.
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Define the roles supported by NearMe Salon.
  ROLES = %w[customer salon_owner admin].freeze

  # A user can own multiple salons.
  has_many :salons, dependent: :destroy

  has_many :appointments, dependent: :destroy

  # Every user must have a name.
  validates :name, presence: true

  # Only allow supported roles.
  validates :role, inclusion: { in: ROLES }

  # Check whether the user is a customer.
  def customer?
    role == "customer"
  end

  # Check whether the user is a salon owner.
  def salon_owner?
    role == "salon_owner"
  end

  # Check whether the user is an administrator.
  def admin?
    role == "admin"
  end
end
