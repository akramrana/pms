class BoardIssue < ActiveRecord::Base
    self.table_name = 'board_issues'
    self.primary_key = 'id'

    belongs_to :board, foreign_key: :boardId, optional: true
    belongs_to :issue, foreign_key: :issueId, optional: true

end