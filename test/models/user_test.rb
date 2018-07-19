require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "example_password",
      password_confirmation: "example_password"
    )
  end

  # General tests

  test "should be valid" do
    assert @user.valid?
  end

  # Name tests

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should be within limits on length" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # Email tests

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should be within limits on length" do
    @user.email = ("a" * 244) + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[
      1234.5678.9_10@should.be.valid.com
      should_match_regex2018@validemail.de
      valid@address.org
      should.be_valid@email.address.cn
      acceptable+email@address.co.uk]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid!}"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[
      invalid@address,com
      legit@address
      real@email@address.com
      real.email@real.email@address.com.exe
      not@a_scam.com
      very@legit+address.co.uk]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid!"
    end
  end

  test "email addresses should be unique" do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      @user.save
      assert_not duplicate_user.valid?
  end

  test "email should be saved as lowercase" do
    mixed_case_email = "UsEr@ExAmPlE.cOm"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # Password Tests

  test "passwords should not be blank" do
      @user.password = @user.password_confirmation = " " * 6
      assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for nil digests." do
    assert_not @user.authenticated?('')
  end
end