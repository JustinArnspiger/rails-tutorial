require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @valid_user = users(:valid_user)
    @admin_user = users(:admin_user)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin_user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin_user
        assert_select 'a[href=?]', user_path(user), text: 'Delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@valid_user)
    end
  end

  test "index as non-admin" do
    log_in_as(@valid_user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
