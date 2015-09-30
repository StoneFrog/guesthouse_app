require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "unsuccesful edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    surname: "",
                                    email: "foo@invalid",
                                    phone: "55a",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
    assert_select "div.alert-danger"
  end

  test "successful edit with friendly forwarding" do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo"
    surname = "Bar"
    email = "foo@bar.com"
    phone = "+48665626264"
    patch user_path(@user), user: { name: name,
                                    surname: surname,
                                    email: email,
                                    phone: phone,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user 
    @user.reload
    assert_equal name, @user.name
    assert_equal surname, @user.surname
    assert_equal phone, @user.phone
    assert_equal email, @user.email
  end

end
