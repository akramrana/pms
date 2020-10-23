class IssueComment < ActiveRecord::Base
    self.table_name = 'issue_comments'
    self.primary_key = 'id'
end