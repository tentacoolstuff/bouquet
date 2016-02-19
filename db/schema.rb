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

ActiveRecord::Schema.define(version: 20160217160347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "dandelion_statuses", force: true do |t|
    t.text "description"
  end

  create_table "dandelions", id: :uuid, force: true do |t|
    t.float   "lati"
    t.float   "longi"
    t.float   "alti"
    t.float   "vFirmware"
    t.integer "n_reports"
    t.string  "nickname",      limit: 1, array: true
    t.float   "moistureLimit"
    t.uuid    "sunflowerID"
  end

  add_index "dandelions", ["sunflowerID"], name: "fki_sunflower", using: :btree

  create_table "peepers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", force: true do |t|
    t.float    "moisture1"
    t.float    "moisture2"
    t.float    "moisture3"
    t.float    "humidity"
    t.integer  "temperature"
    t.float    "batterylevel"
    t.datetime "reporttime"
    t.uuid     "dandelionid"
    t.integer  "stateid",      default: "nextval('"reports_stateID_seq"'::regclass)", null: false
  end

  add_index "reports", ["stateid"], name: "fki_stateID", using: :btree

  create_table "sunflowers", id: :uuid, force: true do |t|
    t.string  "fieldID",   limit: 1, array: true
    t.float   "vFirmware"
    t.string  "ip",        limit: 1, array: true
    t.macaddr "MAC"
    t.string  "nickname",  limit: 1, array: true
  end

  create_table "valve_reports", force: true do |t|
    t.string   "valveid",       limit: 1,                                                                                array: true
    t.datetime "reporttime"
    t.integer  "valvestatusid",           default: "nextval('"valveReports_valveStatusID_seq"'::regclass)", null: false
  end

  add_index "valve_reports", ["valvestatusid"], name: "fki_statusID", using: :btree

  create_table "valve_statuses", force: true do |t|
    t.text "description"
  end

  create_table "valves", force: true do |t|
    t.uuid   "sunflowerID"
    t.string "microbasin",  limit: nil
    t.string "nickname",    limit: 1,   array: true
  end

end
