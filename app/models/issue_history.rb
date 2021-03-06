class IssueHistory < ActiveRecord::Base
    self.table_name = 'issue_histories'
    self.primary_key = 'issue_history_id'

    validates :history_type, :issue_id, :user_id, :created_at, :presence => true

    belongs_to :issue, foreign_key: :issue_id, optional: true
    belongs_to :user, foreign_key: :user_id, optional: true
    
end