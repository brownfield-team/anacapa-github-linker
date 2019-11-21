# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191121031312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "completed_jobs", force: :cascade do |t|
    t.string "job_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.string "summary"
    t.index ["course_id"], name: "index_completed_jobs_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.string "course_organization", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden"
    t.boolean "enable_web_hooks", default: false, null: false
    t.string "slack"
    t.bigint "slack_workspace_id"
    t.index ["slack_workspace_id"], name: "index_courses_on_slack_workspace_id"
  end

  create_table "github_repos", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "course_id"
    t.datetime "last_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repo_id"
    t.index ["course_id"], name: "index_github_repos_on_course_id"
  end

  create_table "github_repos_users", id: false, force: :cascade do |t|
    t.bigint "github_repo_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "hook_events", force: :cascade do |t|
    t.string "hooktype"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.index ["course_id"], name: "index_hook_events_on_course_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "roster_students", force: :cascade do |t|
    t.string "perm"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.bigint "user_id"
    t.boolean "enrolled", default: true
    t.boolean "is_org_member"
    t.index ["course_id"], name: "index_roster_students_on_course_id"
    t.index ["email", "course_id"], name: "index_roster_students_on_email_and_course_id", unique: true
    t.index ["perm", "course_id"], name: "index_roster_students_on_perm_and_course_id", unique: true
    t.index ["user_id"], name: "index_roster_students_on_user_id"
  end

  create_table "slack_workspaces", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.string "bot_access_token"
    t.string "slack_url"
    t.string "scope"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "uid"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "completed_jobs", "courses"
  add_foreign_key "courses", "slack_workspaces"
  add_foreign_key "github_repos", "courses"
  add_foreign_key "hook_events", "courses"
  add_foreign_key "roster_students", "courses"
  add_foreign_key "roster_students", "users"
end
