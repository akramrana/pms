json.extract! notification, :id, :userId, :projectId, :description, :isRead, :createdAt, :updatedAt, :isDeleted, :created_at, :updated_at
json.url notification_url(notification, format: :json)
