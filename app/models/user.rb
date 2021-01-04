require 'bcrypt'

class User < ActiveRecord::Base
    include BCrypt

    def password
        @password ||= Password.new(password_hash)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
    end

    self.table_name = 'users'
    self.primary_key = 'id'
    self.per_page = 10

    validates :username, :email, :password_hash, :usertype, :presence => true

    belongs_to :userType, foreign_key: :usertype, optional: true

    has_many :projects
    has_many :issues



end