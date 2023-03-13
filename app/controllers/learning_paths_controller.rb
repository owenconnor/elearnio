# This controller is responsible for handling the requests for the LearningPath model
class LearningPathsController < ApplicationController

  def record_not_found(e)
    # render json: { error: 'Course not found' }, status: :not_found
    render json: { params: params, error: e.to_s }, status: :not_found
  end
  #@!method index
  # The index action will return all the learning paths
  # It will include the courses and students
  # It will return a 200 status code and a JSON response with the learning paths
  # GET /learning_paths
  def index
    learning_paths = LearningPath.includes(:courses, :student_profiles).all
    render json: learning_paths, each_serializer: LearningPathIndexSerializer, status: :ok
  end

  #@!method show
  # The show action will return a single learning path
  # It will include the courses, students and learning paths
  # It will return a 200 status code and a JSON response with learning path object, course objects and student profile objects
  # If the learning path is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # @param [Integer] id The id of the learning path to be returned
  # GET /learning_paths/:id
  def show
    learning_path = LearningPath.find(params[:id])
    render json: learning_path, serializer: LearningPathShowSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  #@!method create
  # The create action will create a new learning path
  # It will call the LearningPathShowSerializer to return the newly created learning path
  # It will return a 201 status code and a JSON response with the newly created learning path
  # If the learning path is not created, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # @param [String] title The name of the learning path
  def create
    learning_path = LearningPath.create(learning_path_params)
    if learning_path.persisted?
      render json: learning_path, serializer: LearningPathShowSerializer, status: :created
    else
      render json: { errors: learning_path.errors.full_messages, params: learning_path_params }, status: :unprocessable_entity
    end
  rescue RecordNotFound => e
    record_not_found(e)
  end

  #@!method update
  # The update action will update an existing learning path
  # It will call the LearningPathShowSerializer to return the updated learning path
  # It will return a 200 status code and a JSON response with the updated learning path
  # If the learning path is not updated, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # @param [Integer] id The id of the learning path to be updated
  def update
    learning_path = LearningPath.find(params[:id])
    if learning_path.update(learning_path_params)
      render json: learning_path, status: :ok
    else
      render json: { errors: learning_path.errors.full_messages, params: learning_path_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  #@!method destroy
  # The destroy action will delete an existing learning path
  # It will return a 200 status code and a JSON response with the message
  # If the learning path is not deleted, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # @param [Integer] id The id of the learning path to be deleted
  # DELETE /learning_paths/:id
  def destroy
    learning_path = LearningPath.find(params[:id])
    learning_path.destroy
    render json: { message: 'Learning Path deleted successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: e.to_s  }, status: :unprocessable_entity
  end

  #@!method subscribe
  # The subscribe action will subscribe a student to a learning path by creating a new [LearningPathEnrollment]
  # It will call the LearningPathShowSerializer to return the updated learning path
  # It will return a 200 status code and a JSON response with the updated learning path
  # If the learning path is not updated, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # POST /learning_paths/:id/subscribe/:student_profile_id
  # @param [Integer] id The id of the learning path to be subscribed to
  def subscribe
    learning_path = LearningPath.find(params[:id])
    student_profile = StudentProfile.find(params[:student_profile_id])
    learning_path.subscribe_student(student_profile)
    render json: learning_path, serializer: LearningPathShowSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  private
  def learning_path_params
    params.require(:learning_path).permit(:title)
  end
end
