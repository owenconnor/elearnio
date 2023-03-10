class V1::LearningPathsController < ApplicationController

  def record_not_found(e)
    # render json: { error: 'Course not found' }, status: :not_found
    render json: { params: params, error: e.to_s }, status: :not_found
  end
  def index
    learning_paths = LearningPath.all
    render json: learning_paths, status: :ok
  end

  def show
    learning_path = LearningPath.find(params[:id])
    render json: learning_path, serializer: LearningPathShowSerializer, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  end

  def create
    learning_path = LearningPath.create(learning_path_params)
    if learning_path.persisted?
      pp "======== learning_path:#{ learning_path }==============="
      render json: learning_path, status: :created
    else
      render json: { errors: learning_path.errors.full_messages, params: learning_path_params }, status: :unprocessable_entity
    end
  end

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

  def destroy
    learning_path = LearningPath.find(params[:id])
    learning_path.destroy
    render json: { message: 'Learning Path deleted successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    record_not_found(e)
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: e.to_s  }, status: :unprocessable_entity
  end

  private
  def learning_path_params
    params.require(:learning_path).permit(:title)
  end
end
