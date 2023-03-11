class UserShowSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :enrolled_courses, :completed_courses, :learning_paths, :authored_courses, :created_at, :updated_at

  # has_one :student_profile
  # has_one :author_profile

  def enrolled_courses
    object.student_profile.enrolled_courses
  end

  def completed_courses
    object.student_profile.completed_courses
  end

  def learning_paths
    object.student_profile.learning_paths
  end

  def authored_courses
    object.author_profile.courses
  end
end
