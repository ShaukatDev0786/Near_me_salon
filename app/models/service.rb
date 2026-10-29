class Service < ApplicationRecord
  # Every service belongs to a salon.
  belongs_to :salon

  has_many :appointments, dependent: :destroy

  # Basic service validations.
  validates :name, presence: true, length: { maximum: 100 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, numericality: {
    only_integer: true,
    greater_than: 0
  }
end
