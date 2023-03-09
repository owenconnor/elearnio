class V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: users, each_serializer: UserIndexSerializer, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: user, serializer: UserShowSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: params, error: e.to_s }, status: :not_found
  end

  def create
    @user = User.create(user_params)
    if @user.persisted?
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages, params: user_params }, status: :unprocessable_entity
    end
  end

  def update
    #todo: this isn't working correctly
    @user = User.find(user_params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages, params: user_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: user_params, error: e.to_s }, status: :not_found
  rescue
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { message: 'User deleted successfully' }, status: :ok
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
