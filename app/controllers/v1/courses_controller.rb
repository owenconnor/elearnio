class V1::CoursesController < ApplicationController
  def index
    @courses = Course.all
    render json: @courses, status: :ok
  end

  def show
    @course = Course.find(params[:id])
    render json: @course, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  def create
    @course = Course.create(course_params)
    Rails.logger.info "Errors: #{@course.errors.full_messages} -------"
    render json: @course, status: :created
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      render json: @course, status: :ok
    else
      render json: { errors: @course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: course_params, error: e.to_s }, status: :not_found
  end

  def destroy
    @course = Course.find(params[:id])
    if @course.destroy
      head(:ok)
    # else
    #   head(:unprocessable_entity)
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  private
    def course_params
      params.require(:course).permit(:title, :author_profile_id)
    end
end
