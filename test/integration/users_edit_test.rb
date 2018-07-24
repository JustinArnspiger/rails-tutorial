require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @valid_user = users(:valid_user)
  end

  test "Unsuccessful edit" do
    # Make sure the right template is loaded.
    log_in_as(@valid_user)
    get edit_user_path(@valid_user)
    assert_template 'users/edit'

    # Attempt an edit with invalid attributes.
    # This should keep us on the edit page and show 4 errors.
    patch user_path(@valid_user), params: { user: { name: "",
                                                    email: "invalid@emailaddress",
                                                    password: "not",
                                                    password_confirmation: "valid" } }
    assert_template 'users/edit'
    assert_select 'div.alert-danger', "The form contains 4 errors"
  end

  test "Successful edit with friendly forwarding" do
    # Check friendly forwarding.
    get edit_user_path(@valid_user)
    log_in_as(@valid_user)
    assert_redirected_to edit_user_url(@valid_user)
    assert_nil session[:forwarding_url]
    # Edit the user.
    new_valid_name = "New Name"
    new_valid_email = "edited.valid.email@address.fortesting"
    patch user_path(@valid_user), params: { user: { name: new_valid_name,
                                                    email: new_valid_email,
                                                    password: "",
                                                    password_confirmation: "" } }

    # Make sure that the success message is shown and the redirect works correctly.
    assert_not flash.empty?
    assert_redirected_to @valid_user

    # Make sure that the user was actually updated.
    @valid_user.reload
    assert_equal @valid_user.name, new_valid_name
    assert_equal @valid_user.email, new_valid_email
  end
end
