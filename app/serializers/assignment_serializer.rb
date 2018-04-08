class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :project_id
  has_one :user
end
