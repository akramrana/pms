class WelcomeController < ApplicationController
  before_action :logged_in_user
  
  def index
    if session[:usertype]== 1
      @issueActivities = IssueActivity.order('issue_activity_id DESC').limit(5);
      @projects = Project.order("id DESC").where(:is_deleted => 0).limit(5);
      @issues = Issue.where(:is_deleted => 0).limit(5).order('id DESC');
      @boardIssues = BoardIssue.order('count(boardId) DESC').group('boardId').limit(5)

    elsif session[:usertype]== 2
      @userProjects = UserProject.where(userId:session[:user_id])
      @projectsArr = [];

      @userProjects.each do |up|
        @projectsArr.push(up.projectId)
      end

      @projects = Project.order("id DESC")
                         .where(:is_deleted => 0, :id => @projectsArr)
                         .limit(5);

      @issues = Issue.where(issues:{:is_deleted => 0},projects:{:id => @projectsArr})
                      .joins(:project)
                      .limit(5)
                      .order('projects.id DESC');

      @issueActivities = IssueActivity.order('issue_activity_id DESC')
                                      .joins(:issue)
                                      .where(issues:{:projectId => @projectsArr})
                                      .limit(5);

      @boardIssues = BoardIssue.order('count(boards.id) DESC')
                              .joins(:board)
                              .where(boards:{:projectId => @projectsArr})
                              .group('boards.id')
                              .limit(5);

      Rails.logger.debug @projectsArr.inspect
    else

    end
  end

end
