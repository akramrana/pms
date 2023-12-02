class Project < ActiveRecord::Base
    self.table_name = 'projects'
    self.primary_key = 'id'
    self.per_page = 20

    validates :projectName, :projectKey, :projectLeader, :projectPriority, :presence => true

    belongs_to :priorityType, foreign_key: :projectPriority, optional: true
    belongs_to :user, foreign_key: :projectLeader, optional: true
    
    has_many :issues, -> { where(is_deleted: 0) }
    has_many :boards, -> { where(is_deleted: 0) }, :foreign_key => "projectId"
    has_many :userProject, :foreign_key => "projectId"

end