class Salon < ApplicationRecord
  # Each salon belongs to one user.
  belongs_to :user

  # A salon can offer multiple services.
  has_many :services, dependent: :destroy

  has_many :appointments, dependent: :destroy

  # Required salon information.
  validates :name, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :pincode, presence: true

  # Keep the salon name reasonably short.
  validates :name, length: { maximum: 100 }

  # Basic Indian PIN code format: six digits.
  validates :pincode, format: { with: /\A[1-9]\d{5}\z/ }
end
