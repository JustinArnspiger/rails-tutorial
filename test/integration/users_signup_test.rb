require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "not",
                                        password_confirmation: "valid" } }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.alert"
    assert_select "div.alert-danger"
  end

  test "Should flash success message upon valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "New User",
                                          email: "newuser@validaddressfortesting.valid",
                                          password: "thispasswordisvalid",
                                          password_confirmation: "thispasswordisvalid" } }
      end
    follow_redirect!
    assert_template 'users/show'
    assert_select "div.alert-success"
  end
end
