class Notification < ActiveRecord::Base

	self.table_name = 'notifications'
    self.primary_key = 'id'
    self.per_page = 20

    validates :projectId, :userId, :description, :created_at, :updated_at, :presence => true

    belongs_to :project, foreign_key: :projectId, optional: true
    belongs_to :issue, foreign_key: :issueId, optional: true
    belongs_to :user, foreign_key: :userId, optional: true

end
