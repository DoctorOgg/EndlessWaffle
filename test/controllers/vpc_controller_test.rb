require 'test_helper'

class VpcControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get vpc_show_url
    assert_response :success
  end

  test "should get update" do
    get vpc_update_url
    assert_response :success
  end

end
