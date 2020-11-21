class Project < ActiveRecord::Base
    self.table_name = 'projects'
    self.primary_key = 'id'

    validates :projectName, :projectKey, :projectLeader, :projectPriority, :presence => true

    belongs_to :priorityType, foreign_key: :projectPriority, optional: true
    belongs_to :user, foreign_key: :projectLeader, optional: true
    
    has_many :issues

end