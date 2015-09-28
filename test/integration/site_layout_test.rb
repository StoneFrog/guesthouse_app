require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
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
    get signup_path
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href^=?]", reservation_path, count: 2
    get gallery_path
    assert_select "img"
  end

end
