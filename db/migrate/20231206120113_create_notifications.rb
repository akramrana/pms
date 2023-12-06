class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :userId
      t.integer :projectId
      t.text :description
      t.integer :isRead
      t.datetime :createdAt
      t.datetime :updatedAt
      t.integer :isDeleted

      t.timestamps
    end
  end
end
