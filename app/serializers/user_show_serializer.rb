# Purpose: To serialize the user data for the show action
class UserShowSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :enrolled_courses,
             :completed_courses, :subscribed_learning_paths, :completed_learning_paths,
             :authored_courses, :created_at, :updated_at

  # has_one :student_profile
  # has_one :author_profile

  # This is a custom method that we can use to return the enrolled courses
  def enrolled_courses
    object.student_profile.enrolled_courses
  end

  # This is a custom method that we can use to return the completed courses
  def completed_courses
    object.student_profile.completed_courses
  end

  # This is a custom method that we can use to return the subscribed learning paths
  def subscribed_learning_paths
    User.subscribed_learning_paths(object)
  end

  # This is a custom method that we can use to return the completed learning paths
  def completed_learning_paths
    User.completed_learning_paths(object)
  end

  def authored_courses
    object.author_profile.courses
  end
end
