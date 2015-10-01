require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "layout links" do 
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href^=?]", about_path, count: 4
    assert_select "a[href^=?]", activities_path, count: 3
    assert_select "a[href^=?]", gallery_path, count: 2
    assert_select "a[href^=?]", contact_path, count: 1
    assert_select "a[href^=?]", reservation_path, count: 2
    assert_select "a[href^=?]", prices_path
    assert_select "a[href=?]", login_path
    get signup_path
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href^=?]", reservation_path, count: 2
    get gallery_path
    assert_select "img"
    log_in_as(@admin)
    get root_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@admin)
    assert_select "a[href^=?]", edit_user_path(@admin)
    assert_select "a[href^=?]", logout_path
    get edit_user_path(@admin)
    assert_select 'a[href=?]', user_path(@admin), { text: 'delete', count: 0 }
    log_in_as(@non_admin)
    get root_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@non_admin)
    assert_select "a[href^=?]", edit_user_path(@non_admin)
    assert_select "a[href^=?]", logout_path
    get edit_user_path(@non_admin)
    assert_select 'a[href=?]', user_path(@non_admin), { text: 'Delete Account', count: 1 }
  end

end
