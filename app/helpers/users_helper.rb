module UsersHelper
  def user_groups_for_select
    User.groups.map do |group|
      [t("activerecord.attributes.user.group.#{group.first}"), group.first]
    end
  end
end
