class Salon < ApplicationRecord
  # Each salon belongs to one user.
  belongs_to :user

  # A salon can offer multiple services and appointments.
  has_many :services, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  APPROVAL_STATUSES = %w[pending approved rejected].freeze

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

  # Validate salon approval status.
  validates :approval_status, inclusion: { in: APPROVAL_STATUSES }

  # Publicly available salons must be approved.
  scope :approved, -> { where(approval_status: "approved") }
  scope :pending_approval, -> { where(approval_status: "pending") }
end
