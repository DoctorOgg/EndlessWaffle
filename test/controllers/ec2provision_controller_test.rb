require 'test_helper'

class Ec2provisionControllerTest < ActionDispatch::IntegrationTest
  test "should get showjobs" do
    get ec2provision_showjobs_url
    assert_response :success
  end

  test "should get build" do
    get ec2provision_build_url
    assert_response :success
  end

end
