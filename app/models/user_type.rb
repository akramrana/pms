class UserType < ActiveRecord::Base
    self.table_name = 'user_types'
    self.primary_key = 'id'

    validates :userTypeName, :presence => true
end