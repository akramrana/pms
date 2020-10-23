class Project < ActiveRecord::Base
    self.table_name = 'projects'
    self.primary_key = 'id'
end