class InitSchema < ActiveRecord::Migration[5.1]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    create_table "completed_jobs" do |t|
      t.string "job_name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "course_id"
      t.string "summary"
      t.string "job_short_name"
      t.index ["course_id"], name: "index_completed_jobs_on_course_id"
    end
    create_table "courses" do |t|
      t.string "name", null: false
      t.string "course_organization", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "hidden"
    end
    create_table "github_repos" do |t|
      t.string "name"
      t.string "url"
      t.bigint "course_id"
      t.datetime "last_updated_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "repo_id"
      t.string "full_name"
      t.index ["course_id"], name: "index_github_repos_on_course_id"
    end
    create_table "repo_contributors" do |t|
      t.bigint "user_id"
      t.bigint "github_repo_id"
      t.string "permission_level"
      t.index ["github_repo_id"], name: "index_repo_contributors_on_github_repo_id"
      t.index ["user_id"], name: "index_repo_contributors_on_user_id"
    end
    create_table "roles" do |t|
      t.string "name"
      t.string "resource_type"
      t.bigint "resource_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
      t.index ["name"], name: "index_roles_on_name"
      t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
    end
    create_table "roster_students" do |t|
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
    create_table "users" do |t|
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
    create_table "users_roles", id: false do |t|
      t.bigint "user_id"
      t.bigint "role_id"
      t.index ["role_id"], name: "index_users_roles_on_role_id"
      t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
      t.index ["user_id"], name: "index_users_roles_on_user_id"
    end
    add_foreign_key "completed_jobs", "courses"
    add_foreign_key "github_repos", "courses"
    add_foreign_key "roster_students", "courses"
    add_foreign_key "roster_students", "users"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
