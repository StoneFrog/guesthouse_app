require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  # Has to be changed after admin parameter to
  # log_in_as(@admin)
  test "index including pagination" do 
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: "#{user.name}, #{user.surname}"
    end
  end
end
