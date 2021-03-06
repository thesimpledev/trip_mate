class Api::AttendancesController < ApplicationController
  before_action :require_sign_in

  def create
    attendance_request = current_user.managed_attend_requests.find(params[:id])
    @attendance = Attendance.includes(:user).new(
      user: attendance_request.user,
      trip: attendance_request.trip,
    )
    if @attendance.save
      render :show
    else
      render json: {
        errors: @attendance.errors.full_messages,
      }, status: :unprocessable_entity
    end
  end

  def index
    if params[:trip_id] == "undefined"
      @attendances = Attendance.all
    else
      @trip = Trip.find(params[:trip_id])
      @attendances = @trip.attendances.includes(:user)
    end
  end

  def destroy
    attendance = current_user.attendances.find_by(id: params[:id]) ||
      current_user.managed_attendances.find_by(id: params[:id])
    if attendance&.destroy
      render json: attendance, status: :ok
    else
      render json: { errors: ["Failed to leave trip"] }, status: :bad_request
    end
  end
end
