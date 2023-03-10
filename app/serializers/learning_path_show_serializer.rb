class LearningPathShowSerializer < ActiveModel::Serializer
  #TODO: do serializers need to be versioned?
  attributes :id, :title, :courses, :created_at, :updated_at,

  def courses
    object.courses
  end
end
