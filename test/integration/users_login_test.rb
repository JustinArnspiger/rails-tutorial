require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    @valid_user = users(:valid_user)
  end

  test "login should have proper template and form" do
    get login_path
    assert_template 'sessions/new'
    assert_select 'form[action="/login"]'
  end

  test "invalid login" do
    # Post with an invalid login attempt.
    get login_path
    post login_path, params: { session: { email: "invalid_email@address.shouldfail",
                                          password: "invalidpassword" } }

    # Make sure that it flashes an error and stays on the login page.
    assert_template 'sessions/new'
    assert_not flash.empty?

    # Make sure that the flash does not follow to other pages.
    get root_path
    assert flash.empty?
  end

  test "valid login followed by logout" do
    get login_path
    post login_path, params: { session: { email: @valid_user.email,
                                          password: 'password' } }

    # Confirm that the redirect on login works.
    assert_redirected_to @valid_user
    follow_redirect!
    assert_template 'users/show'

    # Confirm that the header updates correctly on login.
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", edit_user_path(@valid_user)
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@valid_user)

    # Confirm that logging out works correctly.
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Simulate multiple clicks on the logout button
    delete logout_path
    follow_redirect!

    # Confirm that the header updates correctly on logout.
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", edit_user_path(@valid_user), count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@valid_user), count: 0
  end

  test "login with remembering" do
    log_in_as(@valid_user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@valid_user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@valid_user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

end
