class IssueActivity < ActiveRecord::Base
    self.table_name = 'issue_activities'
    self.primary_key = 'issue_activity_id'

    validates :description, :issue_id, :user_id, :presence => true

    belongs_to :issue, foreign_key: :issue_id, optional: true
    belongs_to :user, foreign_key: :user_id, optional: true

end