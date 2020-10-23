json.extract! user, :id, :username, :email, :password, :usertype, :createTime, :updateTime, :created_at, :updated_at
json.url user_url(user, format: :json)
