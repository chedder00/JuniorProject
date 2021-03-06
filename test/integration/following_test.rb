require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:chad)
    @other = users(:jerry)
    log_in_as(@user)
  end
  
  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |u|
      assert_select "a[href=?]", user_path(u)
    end
  end
  
  test "followers page" do 
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do|u|
      assert_select "a[href=?]", user_path(u)
    end
  end
  
  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post follows_path, followed_id: @other.id
    end
  end
  
  test "should follow a user with Ajax" do
    #assert_difference '@user.following.count', 1 do
      #xhr :post, follows_path, followed_id: @other.id
    #end
  end
  
  test "should unfollow a user the standard way" do
    @user.follow(@other)
    follow = @user.active_follows.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete follow_path(follow)
    end
  end
  
  test "should unfollow a user using Ajax" do
    #@user.follow(@other)
    #follow = @user.active_follows.find_by(followed_id: @other.id)
    #assert_difference '@user.following.count', -1 do
      # xhr :delete, follow_path(follow)
    #end
  end
  
  
end

















