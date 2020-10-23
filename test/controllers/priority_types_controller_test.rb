require 'test_helper'

class PriorityTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @priority_type = priority_types(:one)
  end

  test "should get index" do
    get priority_types_url
    assert_response :success
  end

  test "should get new" do
    get new_priority_type_url
    assert_response :success
  end

  test "should create priority_type" do
    assert_difference('PriorityType.count') do
      post priority_types_url, params: { priority_type: { priorityTypeName: @priority_type.priorityTypeName } }
    end

    assert_redirected_to priority_type_url(PriorityType.last)
  end

  test "should show priority_type" do
    get priority_type_url(@priority_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_priority_type_url(@priority_type)
    assert_response :success
  end

  test "should update priority_type" do
    patch priority_type_url(@priority_type), params: { priority_type: { priorityTypeName: @priority_type.priorityTypeName } }
    assert_redirected_to priority_type_url(@priority_type)
  end

  test "should destroy priority_type" do
    assert_difference('PriorityType.count', -1) do
      delete priority_type_url(@priority_type)
    end

    assert_redirected_to priority_types_url
  end
end
