require 'test_helper'

class IssueImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue_image = issue_images(:one)
  end

  test "should get index" do
    get issue_images_url
    assert_response :success
  end

  test "should get new" do
    get new_issue_image_url
    assert_response :success
  end

  test "should create issue_image" do
    assert_difference('IssueImage.count') do
      post issue_images_url, params: { issue_image: {  } }
    end

    assert_redirected_to issue_image_url(IssueImage.last)
  end

  test "should show issue_image" do
    get issue_image_url(@issue_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_issue_image_url(@issue_image)
    assert_response :success
  end

  test "should update issue_image" do
    patch issue_image_url(@issue_image), params: { issue_image: {  } }
    assert_redirected_to issue_image_url(@issue_image)
  end

  test "should destroy issue_image" do
    assert_difference('IssueImage.count', -1) do
      delete issue_image_url(@issue_image)
    end

    assert_redirected_to issue_images_url
  end
end
