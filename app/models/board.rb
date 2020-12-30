class Board < ActiveRecord::Base
    self.table_name = 'boards'
    self.primary_key = 'id'

    validates :projectId, :boardName, :presence => true
    belongs_to :project, foreign_key: :projectId, optional: true

    has_many :board_issues, :foreign_key => "boardId"

end