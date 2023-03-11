class LearningPathShowSerializer < ActiveModel::Serializer
  #TODO: do serializers need to be versioned?
  attributes :id, :title, :created_at, :updated_at

  has_many :courses
  has_many :student_profiles

end
