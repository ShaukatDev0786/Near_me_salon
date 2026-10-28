class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Available account roles for NearMe Salon.
  ROLES = %w[customer salon_owner admin].freeze

  # Every user must have a name.
  validates :name, presence: true

  # Only allow roles defined in our application.
  validates :role, inclusion: { in: ROLES }
end
