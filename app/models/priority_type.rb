class PriorityType < ActiveRecord::Base
    self.table_name = 'priority_types'
    self.primary_key = 'id'

    has_many :projects
    has_many :issues
    
    validates :priorityTypeName, :presence => true

end