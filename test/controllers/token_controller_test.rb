require 'test_helper'

class TokenControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get token_get_url
    assert_response :success
  end

  test "should get reset" do
    get token_reset_url
    assert_response :success
  end

end
