class WelcomeController < ApplicationController
  before_action :logged_in_user
  
  def index
    @issueActivities = IssueActivity.order('issue_activity_id DESC').limit(10);
    @projects = Project.order("id DESC").where(:is_deleted => 0).limit(10)
    @issues = Issue.where(:is_deleted => 0).limit(10).order('id DESC')
  end

end
