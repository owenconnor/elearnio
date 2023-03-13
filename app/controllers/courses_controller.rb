class CoursesController < ApplicationController

  # The following is a custom error handler for ActiveRecord::RecordNotFound
  # It will return a 404 status code and a JSON response with the error message
  # and the request parameters
  def record_not_found(e)
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  #@!method
  # The index action will return a list of all courses
  # It will include the author, students, and learning paths
  # It will return a 200 status code and a JSON response with the list of courses
  # If there are no courses, it will return an empty array
  # If there is an error, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # GET /courses
  def index
    courses = Course.includes(:author_profile, :student_profiles, :learning_paths).all
    render json: courses, each_serializer: CourseIndexSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  #@!action show
  # The show action will return a single course
  # It will include the author, students, and learning paths
  # It will return a 200 status code and a JSON response with the course
  # If the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # GET /courses/:id
  def show
    course = Course.find(params[:id])
    if course.valid?
      render json: course, serializer: CourseShowSerializer, status: :ok
    else
      render json: { errors: course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  #@!method create
  # The create action will create a new course
  # It will call the CourseShowSerializer to return the newly created course
  # It will return a 201 status code and a JSON response with the newly created course
  # If the course is not created, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # POST /courses
  # @example
  # {
  # "course": {
  # "title": "New Course",
  # "author_profile_id": 1
  # }
  # }
  # @return [JSON] JSON response with the newly created course
  def create
    course = Course.create(course_params)
    if course.persisted?
      render json: course, serializer: CourseShowSerializer, status: :created
    else
      render json: { errors: course.errors.full_messages, params: course_params }, status: :unprocessable_entity
    end
  end

  #@!method update
  # The update action will update an existing course
  # It will call the CourseShowSerializer to return the updated course
  # It will return a 200 status code and a JSON response with the updated course
  # If the course is not updated, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # if the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # PUT /courses/:id
  # @example
  # {
  # "course": {
  # "title": "New Title"
  # }
  # }
  # @return [JSON] JSON response with the updated course
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

  #@!method destroy
  # The destroy action will delete an existing course
  # It will return a 200 status code and a JSON response with the message
  # If the course is not deleted, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # if the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameter
  # DELETE /courses/:id
  def destroy
    course = Course.find(params[:id])
    if course.destroy
      render json: { message: 'Course deleted successfully' }, status: :ok
    else
      render json: { errors: 'Course could not be deleted', params: params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  #@!method enroll
  # The enroll action will enroll a student in a course by creating a course enrollment object
  # It will return a 201 status code and a JSON response with the course enrollment
  # If the course is not enrolled, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # if the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # @return [JSON] JSON response with the course enrollment
  # @raise [ActiveRecord::RecordNotFound] if the course with the specified ID does not exist
  # @example
  #  POST /courses/:id/enroll
  # {
  #  "student_profile_id": 1
  # }
  # @return [JSON] JSON response with the course enrollment
  def enroll
    course = Course.find(params[:id])
    student_profile = StudentProfile.find(params[:student_profile_id])
    course_enrollment = course.enroll_student(student_profile)
    if course.errors.any?
      render json: { errors: course.errors.full_messages, params: params }, status: :unprocessable_entity
    else
      render json: course_enrollment, status: :created
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  #@!method complete
  # The complete action will mark a course as completed for a student
  # It will return a 200 status code and a JSON response with the message
  # If the course is not completed, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # if the course is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # @example
  # POST /courses/:id/complete
  # {
  # "student_profile_id": 1
  # }
  # @return [JSON] JSON response with the message
  def complete
    course = Course.find(params[:id])
    student_profile = StudentProfile.find(params[:student_profile_id])
    course.complete_course(student_profile)
    if course.errors.any?
      render json: { errors: course.errors.full_messages, params: params }, status: :unprocessable_entity
    else
      # render json: course, status: :ok
      render json: { message: 'Course completed successfully' }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  private
    def course_params
      params.require(:course).permit(:title, :author_profile_id)
    end
end
