class V1::UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    user = User.find(params[:id])
    # render json: user, status: :ok
    render json: user, serializer: UserSerializer, status: :ok
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
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages, params: user_params }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { params: user_params, error: e.to_s }, status: :not_found
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
end
