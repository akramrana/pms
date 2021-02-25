class IssueComment < ActiveRecord::Base
    self.table_name = 'issue_comments'
    self.primary_key = 'id'

    belongs_to :issue, foreign_key: :issueId, optional: true
    belongs_to :user, foreign_key: :userId, optional: true

end