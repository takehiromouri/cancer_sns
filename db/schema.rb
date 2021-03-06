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

ActiveRecord::Schema.define(version: 20170315165601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.string   "hash_id"
    t.index ["member_id"], name: "index_chat_rooms_on_member_id", using: :btree
    t.index ["slug"], name: "index_chat_rooms_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_chat_rooms_on_user_id", using: :btree
  end

  create_table "children", force: :cascade do |t|
    t.integer  "age"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "gender"
    t.index ["user_id"], name: "index_children_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "visible",        default: true, null: false
    t.datetime "deleted_at"
    t.string   "post_type"
    t.string   "photo"
    t.integer  "likes_count",    default: 0
    t.integer  "emotions_count", default: 0
    t.index ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
    t.index ["user_id", "post_id"], name: "index_comments_on_user_id_and_post_id", using: :btree
  end

  create_table "emotions", force: :cascade do |t|
    t.integer  "emotion"
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "post_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "post_type", "user_id"], name: "index_emotions_on_post_id_and_post_type_and_user_id", using: :btree
    t.index ["post_id"], name: "index_emotions_on_post_id", using: :btree
    t.index ["post_type"], name: "index_emotions_on_post_type", using: :btree
    t.index ["user_id"], name: "index_emotions_on_user_id", using: :btree
  end

  create_table "friendships", force: :cascade do |t|
    t.string   "friendable_type"
    t.integer  "friendable_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blocker_id"
    t.integer  "status"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "role",       default: 0
    t.integer  "status",     default: 0, null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id", using: :btree
    t.index ["user_id"], name: "index_group_memberships_on_user_id", using: :btree
  end

  create_table "group_posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "emotions_count", default: 0, null: false
    t.integer  "sads_count",     default: 0
    t.integer  "happies_count",  default: 0
    t.integer  "likes_count",    default: 0
    t.integer  "mads_count",     default: 0
    t.index ["group_id"], name: "index_group_posts_on_group_id", using: :btree
    t.index ["user_id", "group_id"], name: "index_group_posts_on_user_id_and_group_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "group_memberships_count", default: 0
    t.string   "slug"
    t.string   "photo"
    t.boolean  "is_public",               default: true, null: false
    t.integer  "access_type",             default: 0,    null: false
    t.integer  "owner_id"
    t.index ["slug"], name: "index_groups_on_slug", unique: true, using: :btree
  end

  create_table "happies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_happies_on_post_id", using: :btree
    t.index ["user_id"], name: "index_happies_on_user_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id", using: :btree
    t.index ["user_id"], name: "index_likes_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "chat_room_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "photo"
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "news_articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "photo"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "actor_id"
    t.string   "action"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "read_at"
  end

  create_table "post_images", force: :cascade do |t|
    t.string   "photo"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "post_type"
    t.index ["post_id"], name: "index_post_images_on_post_id", using: :btree
    t.index ["user_id"], name: "index_post_images_on_user_id", using: :btree
  end

  create_table "post_taggings", force: :cascade do |t|
    t.integer  "post_tag_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "post_id"
    t.string   "post_type"
    t.index ["post_tag_id"], name: "index_post_taggings_on_post_tag_id", using: :btree
  end

  create_table "post_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "visibility",     default: 0
    t.integer  "emotions_count", default: 0, null: false
    t.integer  "sads_count",     default: 0
    t.integer  "happies_count",  default: 0
    t.integer  "likes_count",    default: 0
    t.integer  "mads_count",     default: 0
    t.string   "title"
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "read_marks", force: :cascade do |t|
    t.string   "readable_type", null: false
    t.integer  "readable_id"
    t.string   "reader_type",   null: false
    t.integer  "reader_id"
    t.datetime "timestamp"
    t.index ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", unique: true, using: :btree
  end

  create_table "sads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_sads_on_post_id", using: :btree
    t.index ["user_id"], name: "index_sads_on_user_id", using: :btree
  end

  create_table "treatments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "default",    default: false, null: false
    t.integer  "user_id"
  end

  create_table "user_treatments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "treatment_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["treatment_id"], name: "index_user_treatments_on_treatment_id", using: :btree
    t.index ["user_id", "treatment_id"], name: "index_user_treatments_on_user_id_and_treatment_id", using: :btree
    t.index ["user_id"], name: "index_user_treatments_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "first_name_katakana"
    t.string   "last_name_katakana"
    t.string   "nickname"
    t.date     "birthday"
    t.integer  "gender"
    t.string   "area"
    t.string   "profession"
    t.string   "partner_age"
    t.string   "cancer_type"
    t.string   "cancer_stage"
    t.string   "hospital"
    t.text     "problems"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "photo"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "profile_completed",      default: false, null: false
    t.jsonb    "settings",               default: {},    null: false
    t.string   "prefecture"
    t.text     "treatment_content"
    t.string   "partner_relationship"
    t.text     "introduction"
    t.string   "other_treatment"
    t.string   "slug"
    t.string   "hash_id"
    t.string   "name"
    t.integer  "partner_gender"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "chat_rooms", "users"
  add_foreign_key "chat_rooms", "users", column: "member_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "messages", "chat_rooms"
  add_foreign_key "messages", "users"
end
