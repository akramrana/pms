class Issue < ActiveRecord::Base
    self.table_name = 'issues'
    self.primary_key = 'id'
    self.per_page = 20

    attr_accessor :boardId

    validates :projectId, :issueTypeId, :summary, :priorityTypeId, :assignee, :boardId, :presence => true

    belongs_to :priorityType, foreign_key: :priorityTypeId, optional: true
    belongs_to :issueType, foreign_key: :issueTypeId, optional: true
    belongs_to :project, foreign_key: :projectId, optional: true
    belongs_to :assigneeUser, :class_name => 'User', foreign_key: :assignee, optional: true
    belongs_to :reporterUser, :class_name => 'User', foreign_key: :reporter, optional: true

    has_many :issueComment, -> { where(is_deleted: 0) }, :foreign_key => "issueId"
    has_many :issueChecklist, -> { where(is_deleted: 0) }, :foreign_key => "issue_id"
    has_many :issueImage, -> { where(is_deleted: 0) }, :foreign_key => "issueId"
    has_many :issueActivity, :foreign_key => "issue_id"

end