class PriorityType < ActiveRecord::Base
    self.table_name = 'priority_types'
    self.primary_key = 'id'

    validates :priorityTypeName, :presence => true
end