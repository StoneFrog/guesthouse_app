require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Welcome to guesthouse_name!"
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get activities" do
    get :activities
    assert_response :success
  end

  test "should get prices" do
    get :prices
    assert_response :success
  end

  test "should get gallery" do
    get :gallery
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
