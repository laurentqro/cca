class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :full_name, :url, :projects, :company, :status, :group

  def full_name
    object.full_name
  end

  def status
    object.account_status
  end

  def group
    I18n.t("activerecord.attributes.user.group.#{object.group}")
  end

  def url
    user_path(object)
  end
end
