class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :projects, :companies, :status, :group

  def full_name
    object.full_name
  end

  def status
    object.account_status
  end

  def group
    I18n.t("activerecord.attributes.user.group.#{object.group}")
  end
end
