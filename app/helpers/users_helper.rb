module UsersHelper
  def projects_for_select
    Project.all.map do |project|
      [project.name, project.id]
    end
  end

  def companies_for_select
    Company.all.map do |company|
      [company.name, company.id]
    end
  end

  def user_groups_for_select
    User.groups.map do |group|
      [t("activerecord.attributes.user.group.#{group.first}"), group.first]
    end
  end
end
