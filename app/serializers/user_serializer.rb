class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :companies

  def full_name
    object.full_name
  end
end
