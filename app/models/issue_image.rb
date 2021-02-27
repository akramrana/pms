class IssueImage < ActiveRecord::Base
    self.table_name = 'issue_images'
    self.primary_key = 'id'

    validates :image, :issueId, :userId, :presence => true

    mount_uploader :image, ImageUploader

    validates :image, file_size: { less_than: 1.megabytes }

    belongs_to :issue, foreign_key: :issueId, optional: true
    belongs_to :user, foreign_key: :userId, optional: true
    
end