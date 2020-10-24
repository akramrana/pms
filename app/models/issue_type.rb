class IssueType < ActiveRecord::Base
    self.table_name = 'issue_types'
    self.primary_key = 'id'

    validates :issueTypeName, :presence => true
end