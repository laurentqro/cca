require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'all users permissions' do
    permission = Permission.new(nil)

    # can view the login page
    assert permission.allow_action?('users/sessions', :new)

    #can login
    assert permission.allow_action?('users/sessions', :create)

    # can view the sign up page
    assert permission.allow_action?('users/registrations', :new)

    #can sign up
    assert permission.allow_action?('users/registrations', :create)

    # can view the reset password page
    assert permission.allow_action?('users/passwords', :new)

    # can ask to reset password
    assert permission.allow_action?('users/passwords', :create)

    # can view the password change form
    assert permission.allow_action?('users/passwords', :edit)

    # can submit new password form
    assert permission.allow_action?('users/passwords', :update)
  end

  test 'any logged in user permissions' do
    user = users(:one)
    permission = Permission.new(user)

    # can visit activities page (home) - avoids redirect loop after sign in
    assert permission.allow_action?('activities', :index)

    # can visit edit a profile page
    assert permission.allow_action?('users/registrations', :edit)

    # can modify his own profile
    assert permission.allow_action?('users/registrations', :update)

    # can log out
    assert permission.allow_action?('users/sessions', :destroy)
  end

  test 'partner permissions' do
    user = users(:one)
    user_project = projects(:one)
    user_project.users << user
    other_project = projects(:two)

    permission = Permission.new(user)

    # can view his own project
    assert permission.allow_action?(:projects, :show, user_project)

    # cannot view another user's project
    assert !permission.allow_action?(:projects, :show, other_project)
  end

  test 'employee permissions' do
    user = users(:one)
    user.employee!
    permission = Permission.new(user)

    # can view a list of all projects
    assert permission.allow_action?(:projects, :index)

    # can view any project
    any_project = projects(:one)
    assert permission.allow_action?(:projects, :show, any_project)

    # can assign a user to a project
    assert permission.allow_action?(:assignments, :create)

    # can unassign a user from a project
    assert permission.allow_action?(:assignments, :destroy)

    # can view the archives
    assert permission.allow_action?(:archives, :index)

    # can only update a partner
    assert permission.allow_action?(:users, :edit, users(:partner))
    assert !permission.allow_action?(:users, :edit, users(:employee))
    assert !permission.allow_action?(:users, :edit, users(:admin))

    # can mark a partner as active/inactive
    assert permission.allow_param?(:user, :active)

    # can view the index of groups
    assert permission.allow_action?(:companies, :index)

    # can create a group
    assert permission.allow_action?(:companies, :new)
    assert permission.allow_action?(:companies, :create)

    # can view a group
    assert permission.allow_action?(:companies, :show)

    # can edit a group
    assert permission.allow_action?(:companies, :edit)
    assert permission.allow_action?(:companies, :update)
  end
end
