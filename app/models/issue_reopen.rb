class IssueReopen < ActiveRecord::Base
    self.table_name = 'issue_reopens'
    self.primary_key = 'id'
end