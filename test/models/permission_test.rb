require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'all users permissions' do
    permission = Permission.new(nil)

    # can view the login page
    assert permission.allow_action?('users/sessions', :new)

    # can login
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

  test 'logged in user can delete a document he owns' do
    user = users(:one)
    project = projects(:pyramid)
    project.users << user

    permission = Permission.new(user)

    s3_url = %r{https://#{ENV['AWS_S3_BUCKET']}.s3.#{ENV['AWS_S3_REGION']}.amazonaws.com}
    stub_request(:put, s3_url).to_return(body: '', status: 200)

    document = Document.create(
      file: File.open('test/fixtures/files/pdf-sample.pdf'),
      folder: project.root_folder,
      user: user
    )

    assert permission.allow_action?(:documents, :destroy, document)
  end

  test 'logged in user can delete a folder provided they are the owner' do
    project = projects(:pyramid)
    user_1 = users(:one)
    user_2 = users(:two)
    permission = Permission.new(user_1)

    folder_1 = Folder.create(name: "Folder 1", user: user_1, project: project)
    folder_2 = Folder.create(name: "Folder 2", user: user_2, project: project)

    assert permission.allow_action?(:folders, :destroy, folder_1)
    assert !permission.allow_action?(:folders, :destroy, folder_2)
  end

  test 'logged in user can delete a folder provided it contains only folders they own' do
    project = projects(:pyramid)
    user_1 = users(:one)
    user_2 = users(:two)
    permission = Permission.new(user_1)

    folder = Folder.create(name: "Parent folder", user: user_1, project: project)
    folder.children.create(name: "Child folder",  user: user_2, project: project)

    assert !permission.allow_action?(:folders, :destroy, folder)
  end

  test 'partner can create folder in project he is assigned to' do
    project = projects(:pyramid)
    user = users(:partner)
    permission = Permission.new(user)

    Assignment.create(user: user, project: project)

    assert permission.allow_action?(:folders, :create, project)
  end

  test 'any logged in user permissions' do
    user = users(:one)
    permission = Permission.new(user)

    # can stop impersonating a user
    assert permission.allow_action?('users', :stop_impersonating)

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
    user_project = projects(:pyramid)
    user_project.users << user
    other_project = projects(:colossus)

    permission = Permission.new(user)

    # can view his own project
    assert permission.allow_action?(:projects, :show, user_project)

    # cannot view another user's project
    assert !permission.allow_action?(:projects, :show, other_project)

    # can view folders inside a project he is assigned to
    assert permission.allow_action?(:folders, :show, user_project)

    # cannot view folders inside a project he is not assigned to
    other_folder = other_project.root_folder
    assert !permission.allow_action?(:folders, :show, other_folder)
  end

  test 'partner can upload a document to a folder inside a project he is assigned to' do
    partner = users(:partner)
    project = projects(:pyramid)
    project.users << partner

    permission = Permission.new(partner)

    assert permission.allow_action?(:documents, :create, project)
  end

  test 'partner cannot upload a document to a folder outside a project he is assigned to' do
    partner = users(:partner)
    project = projects(:pyramid)
    project.users << partner

    permission = Permission.new(partner)

    assert !permission.allow_action?(:documents, :create, projects(:colossus))
  end

  test 'employee permissions' do
    user = users(:one)
    user.employee!
    permission = Permission.new(user)

    # can view a list of all projects
    assert permission.allow_action?(:projects, :index)

    # can view any project
    any_project = projects(:pyramid)
    assert permission.allow_action?(:projects, :show, any_project)

    # can assign a user to a project
    assert permission.allow_action?(:assignments, :create)

    # can view the list of users assigned to a project
    assert permission.allow_action?(:assignments, :index)

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

    # can view the index of companies
    assert permission.allow_action?(:companies, :index)

    # can create a company
    assert permission.allow_action?(:companies, :new)
    assert permission.allow_action?(:companies, :create)

    # can view a company
    assert permission.allow_action?(:companies, :show)

    # can edit a company
    assert permission.allow_action?(:companies, :edit)
    assert permission.allow_action?(:companies, :update)

    # can view the list of users employed by a company
    assert permission.allow_action?(:employments, :index)

    # can add a user to company
    assert permission.allow_action?(:employments, :create)

    # can remove a user from a company
    assert permission.allow_action?(:employments, :destroy)

    # can view a folder
    assert permission.allow_action?(:folders, :show)

    # can create a folder in any project
    assert permission.allow_action?(:folders, :create, any_project)

    # can upload a document to any folder
    assert permission.allow_action?(:documents, :create)
  end
end
