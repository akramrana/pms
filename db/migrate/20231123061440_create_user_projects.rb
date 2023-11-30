class CreateUserProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :user_projects do |t|
      t.integer :projectId
      t.integer :userId
      t.timestamps
    end
  end
end
