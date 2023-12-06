# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_12_06_120113) do

  create_table "board_issues", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "boardId", null: false
    t.integer "issueId", null: false
    t.index ["boardId"], name: "board_issues_FK"
    t.index ["issueId"], name: "board_issues_FK_1"
  end

  create_table "boards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "projectId", null: false
    t.string "boardName", limit: 100
    t.datetime "createdAt", null: false
    t.datetime "updatedAt", null: false
    t.integer "is_deleted", default: 0, null: false
    t.index ["projectId"], name: "boards_FK"
  end

  create_table "issue_activities", primary_key: "issue_activity_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "issue_id", null: false
    t.integer "user_id", null: false
    t.text "description", null: false
    t.datetime "created_at"
    t.index ["issue_id"], name: "FK_issue_activities_issues"
    t.index ["user_id"], name: "FK_issue_activities_users"
  end

  create_table "issue_checklists", primary_key: "issue_checklist_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "issue_id", null: false
    t.integer "user_id", null: false
    t.text "description", null: false
    t.integer "is_completed", limit: 1, default: 0, null: false
    t.integer "completed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "is_deleted", default: 0, null: false
    t.index ["completed_by"], name: "FK_issue_checklists_users_2"
    t.index ["issue_id"], name: "FK_issue_checklists_issues"
    t.index ["user_id"], name: "FK_issue_checklists_users"
  end

  create_table "issue_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "comment", null: false
    t.integer "userId", null: false
    t.integer "issueId", null: false
    t.datetime "time", null: false
    t.integer "is_deleted", default: 0, null: false
    t.index ["issueId"], name: "issue_comments_FK"
    t.index ["userId"], name: "issue_comments_FK_1"
  end

  create_table "issue_histories", primary_key: "issue_history_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.column "history_type", "enum('start','stop','done','reopen')", null: false
    t.integer "issue_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.index ["issue_id"], name: "FK_issue_histories_issues"
    t.index ["user_id"], name: "FK_issue_histories_users"
  end

  create_table "issue_images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "issueId", null: false
    t.string "image", limit: 250, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "is_deleted", limit: 2, default: 0, null: false
    t.index ["issueId"], name: "issue_images_FK"
    t.index ["userId"], name: "issue_images_FK_1"
  end

  create_table "issue_reopens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "issueId", null: false
    t.text "comment", null: false
    t.bigint "time", null: false
    t.index ["issueId"], name: "issue_reopens_FK"
    t.index ["userId"], name: "issue_reopens_FK_1"
  end

  create_table "issue_reviewies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "userId", null: false, comment: "userId = issue reviewed by id"
    t.integer "issueId", null: false
    t.text "comment", null: false
    t.bigint "time", null: false
    t.index ["issueId"], name: "issue_reviewies_FK"
    t.index ["userId"], name: "issue_reviewies_FK_1"
  end

  create_table "issue_source_codes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "source", size: :medium, null: false
    t.integer "userId", null: false
    t.integer "issueId", null: false
    t.text "comment", null: false
    t.bigint "time", null: false
    t.index ["issueId"], name: "issue_source_codes_FK"
    t.index ["userId"], name: "issue_source_codes_FK_1"
  end

  create_table "issue_stops", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "issueId", null: false
    t.text "comment", null: false
    t.bigint "time", null: false
    t.index ["issueId"], name: "issue_stops_FK"
    t.index ["userId"], name: "issue_stops_FK_1"
  end

  create_table "issue_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "issueTypeName", limit: 100, null: false
    t.integer "is_deleted", limit: 1, default: 0, null: false
  end

  create_table "issues", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "projectId", null: false
    t.integer "issueTypeId", null: false
    t.text "summary", null: false
    t.integer "priorityTypeId", null: false
    t.datetime "dueDate"
    t.integer "assignee", null: false
    t.integer "reporter"
    t.text "environment", size: :medium
    t.text "description", size: :long
    t.string "originalEstimate", limit: 100
    t.string "remainEstimate", limit: 200
    t.integer "start", default: 0
    t.integer "stop", default: 0
    t.integer "done", default: 0
    t.integer "reopen", default: 0
    t.datetime "addedTime", null: false
    t.integer "is_deleted", default: 0, null: false
    t.index ["assignee"], name: "issues_FK_3"
    t.index ["issueTypeId"], name: "issues_FK_1"
    t.index ["priorityTypeId"], name: "issues_FK_2"
    t.index ["projectId"], name: "issues_FK"
    t.index ["reporter"], name: "issues_FK_4"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "userId"
    t.integer "projectId"
    t.text "description"
    t.integer "isRead"
    t.datetime "createdAt"
    t.datetime "updatedAt"
    t.integer "isDeleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "priority_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "priorityTypeName", limit: 100, null: false
    t.integer "is_deleted", default: 0, null: false
  end

  create_table "project_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "typeName", limit: 250, null: false
    t.integer "is_deleted", default: 0, null: false
  end

  create_table "project_users", primary_key: "project_user_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.index ["project_id"], name: "FK_project_users_projects"
    t.index ["user_id"], name: "FK_project_users_users"
  end

  create_table "projects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "projectName", limit: 50, null: false
    t.string "projectKey", limit: 25, null: false
    t.integer "projectLeader", null: false
    t.integer "projectPriority", null: false
    t.text "projectDetails", null: false
    t.datetime "time", null: false
    t.integer "is_deleted", default: 0, null: false
    t.index ["projectLeader"], name: "projects_FK"
    t.index ["projectPriority"], name: "projects_FK_1"
  end

  create_table "user_infos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "userId", null: false
    t.text "userAbout", null: false
    t.string "userFirstName", limit: 75, null: false
    t.string "userLastName", limit: 75, null: false
    t.string "userProfilePic", limit: 50, null: false
    t.string "userDOB", limit: 75, null: false
    t.string "userZipCode", limit: 100, null: false
    t.string "userStateId", limit: 11, null: false
    t.integer "userCityId", null: false
    t.text "userAddress", null: false
    t.string "userPhone", limit: 200, null: false
    t.index ["userId"], name: "user_infos_FK"
  end

  create_table "user_projects", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "projectId", null: false
    t.integer "userId", null: false
    t.index ["projectId"], name: "user_projects_FK"
    t.index ["userId"], name: "user_projects_FK_1"
  end

  create_table "user_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "userTypeName", limit: 100, null: false
    t.integer "is_deleted", limit: 1, default: 0, null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "username", limit: 64, null: false
    t.string "email", limit: 64, null: false
    t.string "password_digest", limit: 250
    t.datetime "lastLoginTime"
    t.integer "usertype", null: false
    t.datetime "createTime", null: false
    t.integer "createUserId"
    t.datetime "updateTime", null: false
    t.integer "updateUserId"
    t.integer "is_deleted", default: 0, null: false
  end

  add_foreign_key "board_issues", "boards", column: "boardId", name: "board_issues_FK", on_delete: :cascade
  add_foreign_key "board_issues", "issues", column: "issueId", name: "board_issues_FK_1", on_delete: :cascade
  add_foreign_key "boards", "projects", column: "projectId", name: "boards_FK", on_delete: :cascade
  add_foreign_key "issue_activities", "issues", name: "FK_issue_activities_issues", on_delete: :cascade
  add_foreign_key "issue_activities", "users", name: "FK_issue_activities_users", on_delete: :cascade
  add_foreign_key "issue_checklists", "issues", name: "FK_issue_checklists_issues", on_delete: :cascade
  add_foreign_key "issue_checklists", "users", column: "completed_by", name: "FK_issue_checklists_users_2", on_delete: :cascade
  add_foreign_key "issue_checklists", "users", name: "FK_issue_checklists_users", on_delete: :cascade
  add_foreign_key "issue_comments", "issues", column: "issueId", name: "issue_comments_FK", on_delete: :cascade
  add_foreign_key "issue_comments", "users", column: "userId", name: "issue_comments_FK_1", on_delete: :cascade
  add_foreign_key "issue_histories", "issues", name: "FK_issue_histories_issues", on_update: :cascade
  add_foreign_key "issue_histories", "users", name: "FK_issue_histories_users", on_update: :cascade
  add_foreign_key "issue_images", "issues", column: "issueId", name: "issue_images_FK", on_delete: :cascade
  add_foreign_key "issue_images", "users", column: "userId", name: "issue_images_FK_1", on_delete: :cascade
  add_foreign_key "issue_reopens", "issues", column: "issueId", name: "issue_reopens_FK", on_delete: :cascade
  add_foreign_key "issue_reopens", "users", column: "userId", name: "issue_reopens_FK_1", on_delete: :cascade
  add_foreign_key "issue_reviewies", "issues", column: "issueId", name: "issue_reviewies_FK", on_delete: :cascade
  add_foreign_key "issue_reviewies", "users", column: "userId", name: "issue_reviewies_FK_1", on_delete: :cascade
  add_foreign_key "issue_source_codes", "issues", column: "issueId", name: "issue_source_codes_FK", on_delete: :cascade
  add_foreign_key "issue_source_codes", "users", column: "userId", name: "issue_source_codes_FK_1", on_delete: :cascade
  add_foreign_key "issue_stops", "issues", column: "issueId", name: "issue_stops_FK", on_delete: :cascade
  add_foreign_key "issue_stops", "users", column: "userId", name: "issue_stops_FK_1", on_delete: :cascade
  add_foreign_key "issues", "issue_types", column: "issueTypeId", name: "issues_FK_1", on_delete: :cascade
  add_foreign_key "issues", "priority_types", column: "priorityTypeId", name: "issues_FK_2", on_delete: :cascade
  add_foreign_key "issues", "projects", column: "projectId", name: "issues_FK", on_delete: :cascade
  add_foreign_key "issues", "users", column: "assignee", name: "issues_FK_3", on_delete: :cascade
  add_foreign_key "issues", "users", column: "reporter", name: "issues_FK_4", on_delete: :cascade
  add_foreign_key "project_users", "projects", name: "FK_project_users_projects", on_delete: :cascade
  add_foreign_key "project_users", "users", name: "FK_project_users_users", on_delete: :cascade
  add_foreign_key "projects", "priority_types", column: "projectPriority", name: "projects_FK_1", on_delete: :cascade
  add_foreign_key "projects", "users", column: "projectLeader", name: "projects_FK", on_delete: :cascade
  add_foreign_key "user_infos", "users", column: "userId", name: "user_infos_FK", on_delete: :cascade
  add_foreign_key "user_projects", "projects", column: "projectId", name: "user_projects_FK", on_delete: :cascade
  add_foreign_key "user_projects", "users", column: "userId", name: "user_projects_FK_1", on_delete: :cascade
end
