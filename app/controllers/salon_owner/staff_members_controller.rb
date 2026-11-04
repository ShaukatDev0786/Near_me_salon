class SalonOwner::StaffMembersController < SalonOwner::BaseController
  before_action :set_staff_member, only: [
    :edit,
    :update,
    :destroy,
    :working_hours,
    :update_working_hours
  ]

  def index
    @staff_members = current_salon.staff_members.order(:name)
  end

  def new
    @staff_member = current_salon.staff_members.build
  end

  def create
    @staff_member = current_salon.staff_members.build(staff_member_params)

    if @staff_member.save
      redirect_to salon_owner_staff_members_path, notice: "Staff member added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @staff_member.update(staff_member_params)
      redirect_to salon_owner_staff_members_path, notice: "Staff member updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @staff_member.update!(active: false)

    redirect_to salon_owner_staff_members_path, notice: "Staff member deactivated successfully."
  end

  def working_hours
    @working_hours = (0..6).map do |day|
      @staff_member.staff_working_hours.find_or_initialize_by(day_of_week: day)
    end
  end

  def update_working_hours
    hours_params = params.require(:working_hours)

    StaffWorkingHour.transaction do
      (0..6).each do |day|
        attributes = hours_params.fetch(
          day.to_s,
          ActionController::Parameters.new
        ).permit(:opens_at, :closes_at, :day_off)

        working_hour = @staff_member.staff_working_hours.find_or_initialize_by(
          day_of_week: day
        )

        is_day_off = ActiveModel::Type::Boolean.new.cast(
          attributes[:day_off]
        )

        working_hour.day_off = is_day_off.nil? ? false : is_day_off

        if working_hour.day_off?
          working_hour.opens_at = nil
          working_hour.closes_at = nil
        else
          working_hour.opens_at = attributes[:opens_at]
          working_hour.closes_at = attributes[:closes_at]
        end

        unless working_hour.save
          raise ActiveRecord::RecordInvalid, working_hour
        end
      end
    end

    redirect_to working_hours_salon_owner_staff_member_path(@staff_member),
                notice: "Working hours saved successfully."
  rescue ActiveRecord::RecordInvalid => e
    @working_hours = (0..6).map do |day|
      @staff_member.staff_working_hours.find_or_initialize_by(day_of_week: day)
    end

    flash.now[:alert] =
      "Validation errors: #{e.record.errors.full_messages.join(', ')}"

    render :working_hours, status: :unprocessable_entity
  end

  private

  def current_salon
    @current_salon ||= current_user.salons.first ||
      raise(ActiveRecord::RecordNotFound, "No salon is associated with this account.")
  end

  def set_staff_member
    @staff_member = current_salon.staff_members.find(params[:id])
  end

  def staff_member_params
    params.require(:staff_member).permit(:name, :phone, :active)
  end
end
