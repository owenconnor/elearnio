class UserIndexSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :student_profile_id, :author_profile_id, :created_at, :updated_at

  def student_profile_id
    object.student_profile.id
  end

  def author_profile_id
    object.author_profile.id
  end


end
