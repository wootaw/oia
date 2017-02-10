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

ActiveRecord::Schema.define(version: 20170210084338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "changes", force: :cascade do |t|
    t.string   "version"
    t.integer  "position"
    t.integer  "state"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_changes_on_position", using: :btree
    t.index ["project_id"], name: "index_changes_on_project_id", using: :btree
    t.index ["state"], name: "index_changes_on_state", using: :btree
  end

  create_table "descriptions", force: :cascade do |t|
    t.text     "content"
    t.integer  "version",         default: 0
    t.integer  "state"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "discard_version"
    t.string   "key"
    t.integer  "position"
    t.index ["owner_type", "owner_id"], name: "index_descriptions_on_owner_type_and_owner_id", using: :btree
    t.index ["state"], name: "index_descriptions_on_state", using: :btree
    t.index ["version"], name: "index_descriptions_on_version", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name"
    t.string   "summary"
    t.string   "custom_state"
    t.string   "custom_state_summary"
    t.integer  "state"
    t.integer  "project_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "position"
    t.integer  "version",              default: 0
    t.integer  "discard_version"
    t.index ["name"], name: "index_documents_on_name", using: :btree
    t.index ["project_id"], name: "index_documents_on_project_id", using: :btree
    t.index ["state"], name: "index_documents_on_state", using: :btree
  end

  create_table "flags", force: :cascade do |t|
    t.string   "name"
    t.string   "summary"
    t.integer  "version",         default: 1
    t.integer  "discard_version"
    t.integer  "position"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["discard_version"], name: "index_flags_on_discard_version", using: :btree
    t.index ["name"], name: "index_flags_on_name", using: :btree
    t.index ["owner_type", "owner_id"], name: "index_flags_on_owner_type_and_owner_id", using: :btree
    t.index ["position"], name: "index_flags_on_position", using: :btree
    t.index ["version"], name: "index_flags_on_version", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "state"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state"], name: "index_groups_on_state", using: :btree
    t.index ["team_id"], name: "index_groups_on_team_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_members_on_team_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "name"
    t.integer  "location"
    t.string   "data_type"
    t.string   "summary"
    t.boolean  "required",        default: false
    t.boolean  "array",           default: false
    t.string   "ancestor"
    t.string   "default"
    t.string   "options"
    t.integer  "version",         default: 1
    t.integer  "discard_version"
    t.string   "key"
    t.integer  "state"
    t.integer  "position"
    t.integer  "resource_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["ancestor"], name: "index_parameters_on_ancestor", using: :btree
    t.index ["discard_version"], name: "index_parameters_on_discard_version", using: :btree
    t.index ["key"], name: "index_parameters_on_key", using: :btree
    t.index ["position"], name: "index_parameters_on_position", using: :btree
    t.index ["resource_id"], name: "index_parameters_on_resource_id", using: :btree
    t.index ["state"], name: "index_parameters_on_state", using: :btree
    t.index ["version"], name: "index_parameters_on_version", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "state"
    t.string   "key"
    t.string   "token"
    t.integer  "major_version",   default: 0
    t.integer  "minor_version",   default: 0
    t.integer  "patch_version",   default: 0
    t.integer  "changes_version", default: 0
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["changes_version"], name: "index_projects_on_changes_version", using: :btree
    t.index ["key"], name: "index_projects_on_key", using: :btree
    t.index ["major_version"], name: "index_projects_on_major_version", using: :btree
    t.index ["minor_version"], name: "index_projects_on_minor_version", using: :btree
    t.index ["name"], name: "index_projects_on_name", using: :btree
    t.index ["owner_type", "owner_id"], name: "index_projects_on_owner_type_and_owner_id", using: :btree
    t.index ["patch_version"], name: "index_projects_on_patch_version", using: :btree
    t.index ["state"], name: "index_projects_on_state", using: :btree
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "method"
    t.string   "path"
    t.string   "summary"
    t.string   "custom_state"
    t.string   "custom_state_summary"
    t.integer  "state"
    t.string   "key"
    t.integer  "version",              default: 0
    t.integer  "document_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "position"
    t.integer  "discard_version"
    t.index ["document_id"], name: "index_resources_on_document_id", using: :btree
    t.index ["key"], name: "index_resources_on_key", using: :btree
    t.index ["path"], name: "index_resources_on_path", using: :btree
    t.index ["state"], name: "index_resources_on_state", using: :btree
    t.index ["version"], name: "index_resources_on_version", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.string   "name"
    t.integer  "location"
    t.string   "group"
    t.string   "data_type"
    t.string   "summary"
    t.boolean  "array",           default: false
    t.string   "ancestor"
    t.string   "options"
    t.integer  "version",         default: 1
    t.integer  "discard_version"
    t.string   "key"
    t.integer  "state"
    t.integer  "position"
    t.integer  "resource_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["ancestor"], name: "index_responses_on_ancestor", using: :btree
    t.index ["discard_version"], name: "index_responses_on_discard_version", using: :btree
    t.index ["key"], name: "index_responses_on_key", using: :btree
    t.index ["position"], name: "index_responses_on_position", using: :btree
    t.index ["resource_id"], name: "index_responses_on_resource_id", using: :btree
    t.index ["state"], name: "index_responses_on_state", using: :btree
    t.index ["version"], name: "index_responses_on_version", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_roles_on_group_id", using: :btree
    t.index ["member_id"], name: "index_roles_on_member_id", using: :btree
  end

  create_table "tapes", force: :cascade do |t|
    t.text     "content"
    t.integer  "version"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "state"
    t.string   "schema"
    t.index ["project_id"], name: "index_tapes_on_project_id", using: :btree
    t.index ["version"], name: "index_tapes_on_version", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", using: :btree
    t.index ["state"], name: "index_teams_on_state", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "state"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["state"], name: "index_users_on_state", using: :btree
  end

end
