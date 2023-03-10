class V1::CoursesController < ApplicationController
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(e)
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  def index
    courses = Course.includes(:author_profile, :student_profiles, :learning_paths).all
    render json: courses, each_serializer: CourseIndexSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  def show
    course = Course.find(params[:id])
    if course.persisted?
      render json: course, serializer: CourseShowSerializer, status: :ok
    else
      render json: { errors: course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  def create
    course = Course.create(course_params)
    if course.persisted?
      render json: course, serializer: CourseShowSerializer, status: :created
    else
      render json: { errors: course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  end

  def update
    course = Course.find(params[:id])
    if course.update(course_params)
      render json: course, status: :ok
    else
      render json: { errors: course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end


  def destroy
    #TODO: not quite right, view specs
    course = Course.find(params[:id])
    course.destroy
    render json: { message: 'Course deleted successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: e.to_s  }, status: :unprocessable_entity
  end

  private
    def course_params
      params.require(:course).permit(:title, :author_profile_id)
    end
end
