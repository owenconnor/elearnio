class CourseIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :author_profile_id, :students, :learning_paths, :created_at, :updated_at

  has_one :author_profile

  def students
    object.student_profiles.map(&:id)
  end

  def learning_paths
    object.learning_paths.map(&:id)
  end
end
