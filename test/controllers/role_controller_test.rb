require 'test_helper'

class RoleControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get role_create_url
    assert_response :success
  end

  test "should get edit" do
    get role_edit_url
    assert_response :success
  end

  test "should get show" do
    get role_show_url
    assert_response :success
  end

  test "should get list" do
    get role_list_url
    assert_response :success
  end

  test "should get delete" do
    get role_delete_url
    assert_response :success
  end

end
