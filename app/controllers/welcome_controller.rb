class WelcomeController < ApplicationController
  before_action :logged_in_user
  
  def index
    @projects = [];
    @issues = [];
    @issueActivities = [];
    @boardIssues = [];
      
    if session[:usertype]== 1
      @issueActivities = IssueActivity.order('issue_activity_id DESC').limit(5);
      @projects = Project.order("id DESC").where(:is_deleted => 0).limit(5);
      @issues = Issue.where(:is_deleted => 0).limit(5).order('id DESC');
      @boardIssues = BoardIssue.order('count(boardId) DESC').group('boardId').limit(5)
      @notDoneIssues = Issue.where(:is_deleted => 0, :done => 0).limit(5).order('id DESC');

      @projectCount = Project.where(:is_deleted => 0).count;
      @boardIssuesCount = BoardIssue.count
      @openIssuesCount = Issue.where(:is_deleted => 0, :done => 0).count;
      @doneIssuesCount = Issue.where(:is_deleted => 0, :done => 1).count;

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

      @notDoneIssues = Issue.where(issues:{:is_deleted => 0, :done => 0},projects:{:id => @projectsArr})
                      .joins(:project)
                      .limit(5)
                      .order('projects.id DESC');

      @projectCount = Project.where(:is_deleted => 0, :id => @projectsArr).count;

      @boardIssuesCount = BoardIssue.joins(:board)
                              .where(boards:{:projectId => @projectsArr})
                              .count;

      @openIssuesCount = Issue.where(issues:{:is_deleted => 0, :done => 0},projects:{:id => @projectsArr})
                              .joins(:project)
                              .count;
      
      @doneIssuesCount = Issue.where(issues:{:is_deleted => 0, :done => 1},projects:{:id => @projectsArr})
                              .joins(:project)
                              .count;
      #Rails.logger.debug @projectsArr.inspect
    else
      @userIssues = Issue.where(:assignee => session[:user_id]).group('projectId')
      @projectsArr = [];

      @userIssues.each do |ui|
        @projectsArr.push(ui.projectId)
      end

      @projects = Project.order("id DESC")
                         .where(:is_deleted => 0, :id => @projectsArr)
                         .limit(5);

      @issues = Issue.where(issues:{:is_deleted => 0, :assignee => session[:user_id]})
                      .joins(:project)
                      .limit(5)
                      .order('projects.id DESC');

      @issueActivities = IssueActivity.order('issue_activity_id DESC')
                                      .joins(:issue)
                                      .where(issues:{:assignee => session[:user_id]})
                                      .limit(5);

      @boardIssues = BoardIssue.order('count(boardId) DESC')
                              .joins(:issue)
                              .where(issues:{:assignee => session[:user_id]})
                              .group('boardId')
                              .limit(5);

      @notDoneIssues = Issue.where(issues:{:is_deleted => 0, :done => 0,:assignee => session[:user_id]})
                              .joins(:project)
                              .limit(5)
                              .order('projects.id DESC');

      @projectCount = Project.where(:is_deleted => 0, :id => @projectsArr).count;

      @boardIssuesCount = BoardIssue
                              .joins(:issue)
                              .where(issues:{:assignee => session[:user_id]})
                              .count;

      @openIssuesCount = Issue.where(issues:{:is_deleted => 0, :done => 0, :assignee => session[:user_id]})
                              .joins(:project)
                              .count;                        
      
      @doneIssuesCount = Issue.where(issues:{:is_deleted => 0, :done => 1, :assignee => session[:user_id]})
                              .joins(:project)
                              .count;                        
    end
  end

end
