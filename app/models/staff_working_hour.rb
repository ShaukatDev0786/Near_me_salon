class StaffWorkingHour < ApplicationRecord
  belongs_to :staff_member

  validates :day_of_week, inclusion: { in: 0..6 }, uniqueness: { scope: :staff_member_id }

  validate :working_hours_are_valid

  attribute :day_off, :boolean, default: false

  private

  def working_hours_are_valid
    return if day_off?

    if opens_at.blank? || closes_at.blank?
      errors.add(:base, "Opening and closing times are required for working days")
      return
    end

    if opens_at >= closes_at
      errors.add(:closes_at, "must be later than opening time")
    end
  end
end
