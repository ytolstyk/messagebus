# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141104220603) do

  create_table "devices", force: true do |t|
    t.date     "date"
    t.time     "time"
    t.boolean  "male"
    t.string   "device"
    t.integer  "activity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["activity"], name: "index_devices_on_activity"
  add_index "devices", ["date"], name: "index_devices_on_date"
  add_index "devices", ["device"], name: "index_devices_on_device"
  add_index "devices", ["male"], name: "index_devices_on_male"
  add_index "devices", ["time"], name: "index_devices_on_time"

end
