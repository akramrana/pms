class AppMailer < ApplicationMailer

  default from: 'PMS <mywebapp61@gmail.com>'

  def add_issue_email(issue)
  	@issue = issue

  	@subject = 'PMS: '+@issue.assigneeUser.username+' assigned you '+@issue.summary;
    mail(to: @issue.reporterUser.email, subject: @subject)
  end

  def edit_issue_email(issue)
  	@issue = issue

  	@subject = 'PMS: '+@issue.assigneeUser.username+' updated an issue, assigned to you '+@issue.summary;
    mail(to: @issue.reporterUser.email, subject: @subject)
  end

end
