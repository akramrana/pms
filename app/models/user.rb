require 'bcrypt'

class User < ActiveRecord::Base
    include BCrypt
    has_secure_password

    # def password
    #     @password ||= Password.new(password_hash)
    # end

    # def password=(new_password)
    #     @password = Password.create(new_password)
    #     self.password_hash = @password
    # end

    self.table_name = 'users'
    self.primary_key = 'id'
    self.per_page = 20

    validates :username, :email, :usertype, :presence => true
    validates :password, presence: true, length: { minimum: 6 }

    belongs_to :userType, foreign_key: :usertype, optional: true

    has_many :projects
    has_many :issues

end