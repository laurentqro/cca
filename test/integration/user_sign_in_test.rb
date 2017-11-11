require 'test_helper'

class UserSignInTest < ActionDispatch::IntegrationTest

  test "user sign in followed by sign out" do
    get new_session_url

    session_params = {
      identifier: users(:one).username,
      password: 'password'
    }

    post sessions_url, params: { session: session_params }

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert is_logged_in?

    delete session_url

    assert_not is_logged_in?
    assert_redirected_to new_session_url
  end

  test "logged in user who visits the log in page is taken to the homepage" do
    session_params = {
      session: {
        identifier: users(:one).username,
        password: 'password'
      }
    }

    post sessions_url, params: session_params

    get new_session_url
    assert_redirected_to root_url
  end

  test "user directed to the page he intended to visit before being asked to sign in" do
    get projects_url
    assert_redirected_to new_session_url

    session_params = {
      session: {
        identifier: users(:one).username,
        password: 'password'
      }
    }

    post sessions_url, params: session_params
    assert_redirected_to projects_url
  end
end
