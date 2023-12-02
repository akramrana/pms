class UserProject < ActiveRecord::Base

	self.table_name = 'user_projects'
    self.primary_key = 'id'

    validates :projectId, :userId, :presence => true

    belongs_to :user, foreign_key: :userId
    belongs_to :project, foreign_key: :projectId

end
