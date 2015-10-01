require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example", surname: "User", 
                     email: "user@example.com", phone: "+48665273066",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid?" do
    assert @user.valid?
  end

  test "name should be present" do 
    @user.name = "   "
    assert_not @user.valid?
  end

  test "surname should be present" do 
    @user.surname = "   "
    assert_not @user.valid?
  end

  test "email should be present" do 
    @user.email = "   "
    assert_not @user.valid?
  end

  test "phone may not be present" do 
    @user.phone = "      "
    assert @user.valid?, "#{@user.phone.inspect} should be valid"
  end

  test "name can't be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "surname can't be too long" do
    @user.surname = "a" * 76
    assert_not @user.valid?
  end

  test "email can't be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "phone can't be neither too short nor too long" do
    @user.phone = "a" * 21
    assert_not @user.valid?
    @user.phone = "a" * 6
    assert_not @user.valid?
  end

  test "email validation should accept valid email address" do
    valid_addresses = %w[user@example.com USER@Foo.COM A_US-eR@foo.bar.org
                         first.last@foo.jp alce+boob@baz.ch]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid email address" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..biz]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "phone validation should accept valid phone number" do
    valid_numbers = ["+48 665 273 066", "(665) 062 565 48", "42 671 91 36",
                      "00 420 623 623 623", "42 631-31-31"]
    valid_numbers.each do |valid_number|
      @user.phone = valid_number
      assert @user.valid?, "#{valid_number.inspect} should be valid"
    end
  end

  test "phone validation should not accept invalid phone number" do
    invalid_numbers = ["+48 665 273/066", "(665)x062 565 48", "4AS 671 91 36",
                      "00*420 623 623 623"]
    invalid_numbers.each do |invalid_number|
      @user.phone = invalid_number
      assert_not @user.valid?, "#{invalid_number.inspect} should be invalid"
    end
  end

  test "phone should be standardized" do
    idiotic_phone_numbers = ["+ 69 5-595-595", "+48 (505) 5454545 5"]
    idiotic_phone_numbers.each do |idiotic_phone_number|
      @user.phone = convert_phone_number(idiotic_phone_number)
      @user.save
      assert_equal idiotic_phone_number.tr('\ \-', ""), @user.reload.phone
    end
  end

  test "email should be unique" do 
    duplicate_user = @user.dup 
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcased" do 
    mixed_case_email = "Foo@ExAMPLe.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?(:remember, '')
  end

end
