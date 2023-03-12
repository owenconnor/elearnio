class LearningPathIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :courses, :subscribed_students, :created_at, :updated_at

  def courses
    object.courses.map do |course|
      { id: course.id, title: course.title }
    end
  end

  def subscribed_students
    object.student_profiles.map(&:id)
  end
end