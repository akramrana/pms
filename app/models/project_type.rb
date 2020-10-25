class ProjectType < ActiveRecord::Base
    self.table_name = 'project_types'
    self.primary_key = 'id'

    validates :typeName, :presence => true
end