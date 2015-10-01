require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @other_non_admin = users(:lana)
  end

  test "admin can see every user" do 
    log_in_as(@admin)
    get user_path(@admin)
    assert_response :success
    get user_path(@non_admin)
    assert_response :success
  end

  test "non admin can see only him/herself" do 
    log_in_as(@non_admin)
    get user_path(@admin)
    assert_redirected_to root_url
    get user_path(@other_non_admin)
    assert_redirected_to root_url
    get user_path(@non_admin)
    assert_response :success
  end

end
