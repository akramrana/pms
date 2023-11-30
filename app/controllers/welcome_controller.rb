class WelcomeController < ApplicationController
  before_action :logged_in_user
  
  def index
    @issueActivities = IssueActivity.order('issue_activity_id DESC').limit(5);
    @projects = Project.order("id DESC").where(:is_deleted => 0).limit(5);
    @issues = Issue.where(:is_deleted => 0).limit(5).order('id DESC');
    @boardIssues = BoardIssue.order('count(boardId) DESC').group('boardId').limit(5)
  end

end
