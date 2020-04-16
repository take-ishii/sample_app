require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # 正常な状態かをテスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idが存在しているか（nilでないか）をテスト
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  # データベース上の最初のマイクロポストが、fixture内のマイクロポスト(most_recent)と同じか検証
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end