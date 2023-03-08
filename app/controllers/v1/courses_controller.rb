class V1::CoursesController < ApplicationController
  def index
    @courses = Course.all

    render json: @courses, status: :ok
  end

  def show
    @course = Course.find(params[:id])

    render json: @course, status: :ok
  end

  def create
    @course = Course.new(course_params)
    @course.save
    render json: @course, status: :created
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      render json: @course, status: :created
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @course = Course.find(params[:id])
    if @course.destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private
    def course_params
      params.require(:course).permit(:title, :description, :author_profile_id, :learning_paths)
    end
end
