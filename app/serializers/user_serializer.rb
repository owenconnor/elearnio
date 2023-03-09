class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :courses, :learning_paths, :authored_courses, :created_at, :updated_at

  def courses
    object.student_profile.courses
  end

  def learning_paths
    object.student_profile.learning_paths
  end

  def authored_courses
    object.author_profile.try(:courses)
  end
end
