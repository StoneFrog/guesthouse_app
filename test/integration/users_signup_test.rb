require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do 
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               surname: "",
                               email: "user@invalid",
                               phone: "666x",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.alert-danger"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Example",
                                            surname: "User",
                                            email: "user@example.com",
                                            phone: "+48665273066",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
  end

end
