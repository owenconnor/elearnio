class UserIndexSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :student_profile_id, :author_profile_id, :created_at, :updated_at

  def student_profile_id
    object.student_profile_id
  end

  def author_profile_id
    object.author_profile_id
  end
  # def courses_count
  #   object.student_profile.courses.count
  # end
  #
  # def learning_paths_count
  #   object.student_profile.learning_paths.count
  # end


end
