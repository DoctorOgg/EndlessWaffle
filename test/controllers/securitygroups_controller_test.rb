require 'test_helper'

class SecuritygroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get securitygroups_show_url
    assert_response :success
  end

  test "should get update" do
    get securitygroups_update_url
    assert_response :success
  end

end
