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

ActiveRecord::Schema.define(version: 2021_07_20_233132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "completed_jobs", force: :cascade do |t|
    t.string "job_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.string "summary"
    t.string "job_short_name"
    t.bigint "github_repo_id"
    t.index ["course_id"], name: "index_completed_jobs_on_course_id"
    t.index ["github_repo_id"], name: "index_completed_jobs_on_github_repo_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.string "course_organization", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden"
    t.boolean "github_webhooks_enabled"
    t.string "term"
    t.bigint "school_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "github_repos", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "course_id"
    t.datetime "last_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repo_id"
    t.string "full_name"
    t.string "visibility"
    t.boolean "is_project_repo"
    t.boolean "external"
    t.index ["course_id"], name: "index_github_repos_on_course_id"
  end

  create_table "informed_consents", force: :cascade do |t|
    t.string "perm"
    t.string "name"
    t.bigint "course_id"
    t.boolean "student_consents"
    t.bigint "roster_student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_informed_consents_on_course_id"
    t.index ["perm", "course_id"], name: "index_informed_consents_on_perm_and_course_id", unique: true
    t.index ["roster_student_id", "course_id"], name: "index_informed_consents_on_roster_student_id_and_course_id", unique: true
  end

  create_table "org_teams", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_id"
    t.string "slug"
    t.index ["course_id"], name: "index_org_teams_on_course_id"
  end

  create_table "org_webhook_events", force: :cascade do |t|
    t.datetime "date_triggered"
    t.string "event_type"
    t.string "payload"
    t.bigint "course_id"
    t.bigint "roster_student_id"
    t.bigint "github_repo_id"
    t.index ["course_id"], name: "index_org_webhook_events_on_course_id"
    t.index ["github_repo_id"], name: "index_org_webhook_events_on_github_repo_id"
    t.index ["roster_student_id"], name: "index_org_webhook_events_on_roster_student_id"
  end

  create_table "org_webhooks", force: :cascade do |t|
    t.integer "hook_id"
    t.bigint "course_id"
    t.string "hook_url"
    t.index ["course_id"], name: "index_org_webhooks_on_course_id"
  end

  create_table "orphan_emails", force: :cascade do |t|
    t.string "email"
    t.bigint "course_id"
    t.bigint "roster_student_id"
    t.index ["course_id"], name: "index_orphan_emails_on_course_id"
    t.index ["roster_student_id"], name: "index_orphan_emails_on_roster_student_id"
  end

  create_table "orphan_names", force: :cascade do |t|
    t.string "name"
    t.bigint "course_id"
    t.bigint "roster_student_id"
    t.index ["course_id"], name: "index_orphan_names_on_course_id"
    t.index ["roster_student_id"], name: "index_orphan_names_on_roster_student_id"
  end

  create_table "project_roles", force: :cascade do |t|
    t.string "name"
    t.string "color"
  end

  create_table "project_teams", force: :cascade do |t|
    t.string "name"
    t.string "qa_url"
    t.string "production_url"
    t.string "team_chat_url"
    t.string "meeting_time"
    t.bigint "course_id"
    t.bigint "github_repo_id"
    t.bigint "org_team_id"
    t.string "repo_url"
    t.string "project"
    t.string "milestones_url"
    t.string "project_board_url"
    t.index ["course_id"], name: "index_project_teams_on_course_id"
    t.index ["github_repo_id"], name: "index_project_teams_on_github_repo_id"
    t.index ["org_team_id"], name: "index_project_teams_on_org_team_id"
  end

  create_table "repo_commit_events", force: :cascade do |t|
    t.bigint "github_repo_id"
    t.bigint "roster_student_id"
    t.string "message"
    t.string "commit_hash"
    t.string "url"
    t.string "branch"
    t.integer "files_changed"
    t.datetime "commit_timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filenames_changed"
    t.boolean "committed_via_web"
    t.string "author_login"
    t.string "author_name"
    t.string "author_email"
    t.integer "additions"
    t.integer "deletions"
    t.index ["github_repo_id"], name: "index_repo_commit_events_on_github_repo_id"
    t.index ["roster_student_id"], name: "index_repo_commit_events_on_roster_student_id"
  end

  create_table "repo_contributors", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "github_repo_id"
    t.string "permission_level"
    t.index ["github_repo_id"], name: "index_repo_contributors_on_github_repo_id"
    t.index ["user_id"], name: "index_repo_contributors_on_user_id"
  end

  create_table "repo_issue_events", force: :cascade do |t|
    t.bigint "roster_student_id"
    t.bigint "github_repo_id"
    t.string "issue_id"
    t.string "url"
    t.string "action_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "body"
    t.string "state"
    t.boolean "closed"
    t.datetime "closed_at"
    t.integer "assignee_count"
    t.string "assignee_logins"
    t.string "assignee_names"
    t.integer "project_card_count"
    t.string "project_card_column_names"
    t.string "project_card_column_project_names"
    t.string "project_card_column_project_urls"
    t.datetime "issue_created_at"
    t.string "author_login"
    t.integer "number"
    t.index ["github_repo_id"], name: "index_repo_issue_events_on_github_repo_id"
    t.index ["roster_student_id"], name: "index_repo_issue_events_on_roster_student_id"
  end

  create_table "repo_pull_request_events", force: :cascade do |t|
    t.bigint "github_repo_id"
    t.bigint "roster_student_id"
    t.string "url"
    t.string "pr_id"
    t.string "action_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "body"
    t.string "state"
    t.string "reviewDecision"
    t.integer "changedFiles"
    t.boolean "closed"
    t.datetime "closed_at"
    t.boolean "merged"
    t.datetime "merged_at"
    t.integer "assignee_count"
    t.string "assignee_logins"
    t.string "assignee_names"
    t.integer "project_card_count"
    t.string "project_card_column_names"
    t.string "project_card_column_project_names"
    t.string "project_card_column_project_urls"
    t.datetime "pull_request_created_at"
    t.string "author_login"
    t.index ["github_repo_id"], name: "index_repo_pull_request_events_on_github_repo_id"
    t.index ["roster_student_id"], name: "index_repo_pull_request_events_on_roster_student_id"
  end

  create_table "repo_team_contributors", force: :cascade do |t|
    t.bigint "org_team_id"
    t.bigint "github_repo_id"
    t.string "permission_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_repo_id"], name: "index_repo_team_contributors_on_github_repo_id"
    t.index ["org_team_id"], name: "index_repo_team_contributors_on_org_team_id"
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
    t.string "org_membership_type"
    t.string "section"
    t.index ["course_id"], name: "index_roster_students_on_course_id"
    t.index ["email", "course_id"], name: "index_roster_students_on_email_and_course_id", unique: true
    t.index ["perm", "course_id"], name: "index_roster_students_on_perm_and_course_id", unique: true
    t.index ["user_id"], name: "index_roster_students_on_user_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_users", force: :cascade do |t|
    t.string "uid"
    t.string "username"
    t.string "display_name"
    t.string "email"
    t.bigint "roster_student_id"
    t.bigint "slack_workspace_id"
    t.index ["roster_student_id"], name: "index_slack_users_on_roster_student_id"
    t.index ["slack_workspace_id"], name: "index_slack_users_on_slack_workspace_id"
  end

  create_table "slack_workspaces", force: :cascade do |t|
    t.string "name"
    t.string "user_access_token"
    t.string "bot_access_token"
    t.string "scope"
    t.string "team_id"
    t.string "app_id"
    t.bigint "course_id"
    t.index ["course_id"], name: "index_slack_workspaces_on_course_id"
  end

  create_table "student_team_memberships", force: :cascade do |t|
    t.bigint "roster_student_id"
    t.bigint "org_team_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_role_id"
    t.index ["org_team_id"], name: "index_student_team_memberships_on_org_team_id"
    t.index ["project_role_id"], name: "index_student_team_memberships_on_project_role_id"
    t.index ["roster_student_id"], name: "index_student_team_memberships_on_roster_student_id"
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
  add_foreign_key "completed_jobs", "github_repos"
  add_foreign_key "courses", "schools"
  add_foreign_key "github_repos", "courses"
  add_foreign_key "org_webhook_events", "courses"
  add_foreign_key "org_webhook_events", "github_repos"
  add_foreign_key "org_webhook_events", "roster_students"
  add_foreign_key "org_webhooks", "courses"
  add_foreign_key "project_teams", "github_repos"
  add_foreign_key "project_teams", "org_teams"
  add_foreign_key "repo_commit_events", "github_repos"
  add_foreign_key "repo_commit_events", "roster_students"
  add_foreign_key "repo_issue_events", "github_repos"
  add_foreign_key "repo_issue_events", "roster_students"
  add_foreign_key "repo_pull_request_events", "github_repos"
  add_foreign_key "repo_pull_request_events", "roster_students"
  add_foreign_key "roster_students", "courses"
  add_foreign_key "roster_students", "users"
  add_foreign_key "slack_users", "slack_workspaces"
  add_foreign_key "student_team_memberships", "project_roles"
end
