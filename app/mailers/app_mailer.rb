class AppMailer < ApplicationMailer

  default from: 'PMS <mywebapp61@gmail.com>'

  def add_issue_email(issue)
  	@issue = issue

  	@subject = 'PMS: '+@issue.reporterUser.username+' assigned you '+@issue.summary;
    mail(to: @issue.assigneeUser.email, subject: @subject)
  end

  def edit_issue_email(issue)
  	@issue = issue

  	@subject = 'PMS: '+@issue.reporterUser.username+' updated an issue, assigned to you '+@issue.summary;
    mail(to: @issue.assigneeUser.email, subject: @subject)
  end

  def comment_issue_email(issueComment, session)
    @issueComment = issueComment
    @session = session
    if @session[:user_id] != @issueComment.issue.assignee

      @subject = 'PMS: '+@issueComment.user.username+' added a comment to '+@issueComment.issue.summary;
      mail(to: @issueComment.issue.assigneeUser.email, subject: @subject)

    end
  end

  def checklist_issue_email(issueChecklist,session)
    @issueChecklist = issueChecklist
    @session = session

    if @session[:user_id] != @issueChecklist.issue.assignee

      @subject = 'PMS: '+@issueChecklist.user.username+' added a checklist item to '+@issueChecklist.issue.summary;
      mail(to: @issueChecklist.issue.assigneeUser.email, subject: @subject)

    end

  end

  def attachment_issue_email(issueImage,session)
    @issueImage = issueImage
    @session = session

    if @session[:user_id] != @issueImage.issue.assignee

      @subject = 'PMS: '+@issueImage.user.username+' added an attachment to '+@issueImage.issue.summary;
      mail(to: @issueImage.issue.assigneeUser.email, subject: @subject)

    end

  end

  def reopen_issue_email(issueHistory,issue,session)
    @issue = issue
    @session = session
    @issueHistory = issueHistory

    if @session[:user_id] != @issue.assignee
      @subject = 'PMS: '+@issueHistory.user.username+' re-open an issue, assigned to you '+@issue.summary;
      mail(to: @issue.assigneeUser.email, subject: @subject)
    end

  end

end
