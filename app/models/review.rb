class Review < ApplicationRecord
  belongs_to :user
  belongs_to :salon
  belongs_to :appointment

  validates :rating, presence: true, inclusion: { in: 1..5 }

  validates :comment, length: { maximum: 2000 }

  validates :appointment_id, uniqueness: true

  validate :appointment_must_be_completed
  validate :appointment_must_belong_to_customer_and_salon

  private

  def appointment_must_be_completed
    return if appointment.blank?
    return if appointment.status == "completed"

    errors.add(:appointment, "must be completed before reviewing")
  end

  def appointment_must_belong_to_customer_and_salon
    return if appointment.blank?

    if appointment.user_id != user_id
      errors.add(:user, "must be the customer who booked the appointment")
    end

    if appointment.salon_id != salon_id
      errors.add(:salon, "must match the appointment salon")
    end
  end
end