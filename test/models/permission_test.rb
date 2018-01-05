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
  end

  test 'any logged in user permissions' do
    user = users(:one)
    permission = Permission.new(user)

    # can visit edit profile page
    assert permission.allow_action?('users/registrations', :edit)

    # can modify profile
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
    any_project = projects(:one)

    permission = Permission.new(user)

    # can view any project
    assert permission.allow_action?(:projects, :show, any_project)

    # can assign a user to a project
    assert permission.allow_action?(:assignments, :create)

    # can unassign a user from a project
    assert permission.allow_action?(:assignments, :destroy)

    # can view the archives
    assert permission.allow_action?(:archives, :index)
  end
end
