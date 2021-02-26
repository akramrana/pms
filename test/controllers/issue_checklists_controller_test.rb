require 'test_helper'

class IssueChecklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue_checklist = issue_checklists(:one)
  end

  test "should get index" do
    get issue_checklists_url
    assert_response :success
  end

  test "should get new" do
    get new_issue_checklist_url
    assert_response :success
  end

  test "should create issue_checklist" do
    assert_difference('IssueChecklist.count') do
      post issue_checklists_url, params: { issue_checklist: {  } }
    end

    assert_redirected_to issue_checklist_url(IssueChecklist.last)
  end

  test "should show issue_checklist" do
    get issue_checklist_url(@issue_checklist)
    assert_response :success
  end

  test "should get edit" do
    get edit_issue_checklist_url(@issue_checklist)
    assert_response :success
  end

  test "should update issue_checklist" do
    patch issue_checklist_url(@issue_checklist), params: { issue_checklist: {  } }
    assert_redirected_to issue_checklist_url(@issue_checklist)
  end

  test "should destroy issue_checklist" do
    assert_difference('IssueChecklist.count', -1) do
      delete issue_checklist_url(@issue_checklist)
    end

    assert_redirected_to issue_checklists_url
  end
end
