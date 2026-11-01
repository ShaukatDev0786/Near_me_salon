
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: [:create]
  before_action :set_review, only: [:destroy]

  def create
    unless current_user.customer?
      redirect_to salon_path(@appointment.salon), alert: "Only customers can submit reviews."
      return
    end

    unless @appointment.user_id == current_user.id
      redirect_to salon_path(@appointment.salon), alert: "You can only review your own appointments."
      return
    end

    @review = Review.new(review_params)
    @review.user = current_user
    @review.appointment = @appointment
    @review.salon = @appointment.salon

    if @review.save
      redirect_to discover_salon_path(@appointment.salon), notice: "Thank you! Your review was submitted."
    else
      redirect_to discover_salon_path(@appointment.salon), alert: @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    unless current_user.admin? || @review.user_id == current_user.id
      redirect_to discover_salon_path(@review.salon), alert: "You are not authorized to delete this review."
      return
    end

    salon = @review.salon
    @review.destroy

    redirect_to discover_salon_path(salon), notice: "Review deleted successfully."
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id] || params.dig(:review, :appointment_id))
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
