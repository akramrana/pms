class Issue < ActiveRecord::Base
    self.table_name = 'issues'
    self.primary_key = 'id'
end