require 'test_helper'

class ReservationsControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @reservation = reservations(:first)
  end
  
  test "should get new with blank fields when no user logged in" do 
    get :new
    assert_response :success
    assert_select "input[id=reservation_name][value]", 0
  end

  test "should get new with filled fields when user is logged" do 
    log_in_as(@user)
    get :new
    assert_response :success
    assert_select "input[id=reservation_name][value=?]", @user.name
  end

end
