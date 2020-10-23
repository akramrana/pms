class UserInfo < ActiveRecord::Base
    self.table_name = 'user_infos'
    self.primary_key = 'id'
end