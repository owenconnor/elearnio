class CourseShowSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :students,  :learning_paths, :created_at, :updated_at

  def author
    {
      id: object.author_profile.id,
      first_name: object.author_profile.user.first_name,
      last_name: object.author_profile.user.last_name,
      email: object.author_profile.user.email
    }
  end

  def students
    object.student_profiles
  end
end
