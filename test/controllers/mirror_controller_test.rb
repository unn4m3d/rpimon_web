require 'test_helper'

class MirrorControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
