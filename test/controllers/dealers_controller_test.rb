require 'test_helper'

class DealersControllerTest < ActionController::TestCase
  test "should get register" do
    get :register
    assert_response :success
  end

end
