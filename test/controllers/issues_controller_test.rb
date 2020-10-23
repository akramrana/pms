require 'test_helper'

class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue = issues(:one)
  end

  test "should get index" do
    get issues_url
    assert_response :success
  end

  test "should get new" do
    get new_issue_url
    assert_response :success
  end

  test "should create issue" do
    assert_difference('Issue.count') do
      post issues_url, params: { issue: { addedTime: @issue.addedTime, assignee: @issue.assignee, description: @issue.description, dueDate: @issue.dueDate, environment: @issue.environment, issueTypeId: @issue.issueTypeId, originalEstimate: @issue.originalEstimate, prioritypeId: @issue.prioritypeId, projectId: @issue.projectId, remainEstimate: @issue.remainEstimate, reporter: @issue.reporter, summary: @issue.summary } }
    end

    assert_redirected_to issue_url(Issue.last)
  end

  test "should show issue" do
    get issue_url(@issue)
    assert_response :success
  end

  test "should get edit" do
    get edit_issue_url(@issue)
    assert_response :success
  end

  test "should update issue" do
    patch issue_url(@issue), params: { issue: { addedTime: @issue.addedTime, assignee: @issue.assignee, description: @issue.description, dueDate: @issue.dueDate, environment: @issue.environment, issueTypeId: @issue.issueTypeId, originalEstimate: @issue.originalEstimate, prioritypeId: @issue.prioritypeId, projectId: @issue.projectId, remainEstimate: @issue.remainEstimate, reporter: @issue.reporter, summary: @issue.summary } }
    assert_redirected_to issue_url(@issue)
  end

  test "should destroy issue" do
    assert_difference('Issue.count', -1) do
      delete issue_url(@issue)
    end

    assert_redirected_to issues_url
  end
end
