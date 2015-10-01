require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:lana)
    @another_user = users(:archer)
  end

  #to be refactored when admin parameter will be added
  #test "should redirect index when not admin" do 
  #  get :index
  #  assert_redirected_to root_url
  #end
  test "should redirect index when not logged in" do 
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "redirect when not logged user tries to edit" do 
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "redirect when not logged user tries to update" do 
    patch :update, id: @user, user: { name: @user.name, 
                                      surname: @user.surname, 
                                      email: @user.email,
                                      phone: @user.phone }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do 
    log_in_as(@another_user)
    get :edit, id: @user 
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do 
    log_in_as(@another_user)
    patch :update, id: @user, user: { name: @user.name, 
                                      surname: @user.surname, 
                                      email: @user.email,
                                      phone: @user.phone }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do 
    assert_no_difference 'User.count' do 
      delete :destroy, id: @user 
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do 
    log_in_as(@another_user)
    assert_no_difference 'User.count' do 
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  #Add test to destroy as admin - should work 
  #Add test to destroy other non admin - shouldn't work - can be the existing one

  test "should not allow the admin attribute to be edited via the web" do 
    log_in_as(@another_user)
    assert_not @another_user.admin?
    patch :update, id: @another_user, user: { password: "password",
                                              password_confirmation: "password",
                                              admin: true }
    assert_not @another_user.reload.admin?
  end
end
