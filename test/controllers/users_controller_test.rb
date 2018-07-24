require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @valid_user = users(:valid_user)
    @other_user = users(:other_user)
    @admin_user = users(:admin_user)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "Should redirect edit when not logged in." do
    get edit_user_path(@valid_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "Should redirect update when not logged in." do
    patch user_path(@valid_user), params: { user: { name: @valid_user.name,
                                                    email: @valid_user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "Should redirect edit when logged in as different user." do
    log_in_as(@other_user)
    get edit_user_path(@valid_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect update when logged in as different user." do
    log_in_as(@other_user)
    patch user_path(@valid_user), params: { user: { name: @valid_user.name,
                                                    email: @valid_user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "Should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "Should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password: "",
                                            password_confirmation: "",
                                            admin: 1 } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@valid_user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@valid_user)
    end
    assert_redirected_to root_url
  end

end