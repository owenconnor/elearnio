class UserShowSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :courses, :learning_paths, :authored_courses, :created_at, :updated_at

  # has_one :student_profile
  # has_one :author_profile

  def courses
    if object.student_profile && object.student_profile.courses
      object.student_profile.courses
    else
      []
    end
  end

  def learning_paths
    if object.student_profile && object.student_profile.learning_paths
      object.student_profile.learning_paths
    else
      []
    end
  end

  def authored_courses
    if object.author_profile && object.author_profile.courses
      object.author_profile.courses
    else
      []
    end
  end
end
