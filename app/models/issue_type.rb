class IssueType < ActiveRecord::Base
    self.table_name = 'issue_types'
    self.primary_key = 'id'

    has_many :issues

    validates :issueTypeName, :presence => true
    
end