class UsersController < ApplicationController
  #@!method index
  # The index action will return a list of all users
  # It will include the student profile and author profile
  # It will return a 200 status code and a JSON response with the list of users
  # If there are no users, it will return an empty array
   def index
    users = User.includes(:student_profile, :author_profile).all
    render json: users, each_serializer: UserIndexSerializer, status: :ok
  end

  #@!method show
  # The show action will return a single user
  # It will include the student profile and author profile, enrolled courses,completed courses, and subscribed learning paths
  # It will return a 200 status code and a JSON response with the user
  # If the user is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # @param [Integer] id The id of the user.
  # GET /users/:id
  def show
    user = User.find(params[:id])
    render json: user, serializer: UserShowSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  # @!method create
  # The create action will create a new user
  # It will call the UserShowSerializer to return the newly created user
  # It will return a 201 status code and a JSON response with the newly created user
  # If the user is not created, it will return a 422 status code and a JSON response with the error message
  # and the request parameters
  # POST /users
  # @param [String] email The email of the user.
  # @param [String] first_name The first name of the user.
  # @param [String] last_name The last name of the user.
  def create
    @user = User.create(user_params)
    if @user.persisted?
      render json: @user, serializer: UserShowSerializer, status: :created
    else
      render json: { errors: @user.errors.full_messages, params: user_params }, status: :unprocessable_entity
    end
  end

  # @!method update
  # The update action will update an existing user
  # It will call the UserShowSerializer to return the updated user
  # It will return a 200 status code and a JSON response with the updated user
  # if the user is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # PUT /users/:id
  # @param [String] email The email of the user.
  # @param [String] first_name The first name of the user.
  # @param [String] last_name The last name of the user.
  # @param [Integer] id The id of the user.
  def update
    #todo: this isn't working correctly
    @user = User.find(user_params[:id])
    if @user.update(user_params)
      render json: @user, serializer: UserShowSerializer, status: :ok
    else
      render json: { errors: @user.errors.full_messages, params: user_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: user_params, error: e.to_s }, status: :not_found
  rescue
  end

  # @!method destroy
  # The destroy action will delete an existing user
  # It will return a 200 status code and a JSON response with the message
  # if the user is not found, it will return a 404 status code and a JSON response with the error message
  # and the request parameters
  # DELETE /users/:id
  # @param [Integer] id The id of the user.
  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }, status: :not_found
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: e.to_s  }, status: :unprocessable_entity
  end

  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
