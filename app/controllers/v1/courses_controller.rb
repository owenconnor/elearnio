class V1::CoursesController < ApplicationController

  # The following is a custom error handler for ActiveRecord::RecordNotFound
  # It will return a 404 status code and a JSON response with the error message
  # and the request parameters
  def record_not_found(e)
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  # The index action will return a list of all courses
  # It will include the author, students, and learning paths
  # It will return a 200 status code and a JSON response with the list of courses
  # If there are no courses, it will return an empty array
  # If there is an error, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # GET /v1/courses
  def index
    courses = Course.includes(:author_profile, :student_profiles, :learning_paths).all
    render json: courses, each_serializer: CourseIndexSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  # The show action will return a single course
  # It will include the author, students, and learning paths
  # It will return a 200 status code and a JSON response with the course
  # If the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # GET /v1/courses/:id
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

  # The create action will create a new course
  # It will call the CourseShowSerializer to return the newly created course
  # It will return a 201 status code and a JSON response with the newly created course
  # If the course is not created, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # POST /v1/courses
  #
  def create
    course = Course.create(course_params)
    if course.persisted?
      render json: course, serializer: CourseShowSerializer, status: :created
    else
      render json: { errors: course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  end

  # The update action will update an existing course
  # It will call the CourseShowSerializer to return the updated course
  # It will return a 200 status code and a JSON response with the updated course
  # If the course is not updated, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # if the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # PUT /v1/courses/:id
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

  def enroll
    course = Course.find(params[:id])
    student_profile = StudentProfile.find(params[:student_profile_id])
    course_enrollment = course.enroll_student(student_profile)
    if course_enrollment.persisted?
      render json: course_enrollment, status: :created
    else
      render json: { errors: course_enrollment.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  def complete
    course = Course.find(params[:id])
    student_profile = StudentProfile.find(params[:student_profile_id])
    course.complete_course(student_profile)
    render json: { message: 'Course completed successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  private
    def course_params
      params.require(:course).permit(:title, :author_profile_id)
    end
end
