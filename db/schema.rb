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

ActiveRecord::Schema.define(version: 20160806210602) do

  create_table "amis", force: :cascade do |t|
    t.string   "availability_zone"
    t.string   "name"
    t.string   "version"
    t.string   "arch"
    t.string   "instance_type"
    t.integer  "release"
    t.string   "ami_id"
    t.string   "aki_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["aki_id"], name: "index_amis_on_aki_id"
    t.index ["ami_id"], name: "index_amis_on_ami_id"
    t.index ["availability_zone"], name: "index_amis_on_availability_zone"
    t.index ["name"], name: "index_amis_on_name"
    t.index ["version"], name: "index_amis_on_version"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.boolean  "admin",        default: false
    t.string   "user"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token"
  end

  create_table "ec2s", force: :cascade do |t|
    t.string   "instanceId"
    t.string   "ownerId"
    t.string   "imageId"
    t.string   "keyName"
    t.integer  "amiLaunchIndex"
    t.string   "instanceType"
    t.string   "kernelId"
    t.string   "hypervisor"
    t.string   "architecture"
    t.boolean  "sourceDestCheck"
    t.string   "clientToken"
    t.text     "networkInterfaces"
    t.text     "placement"
    t.text     "iamInstanceProfile"
    t.text     "instanceState"
    t.text     "monitoring"
    t.text     "productCodes"
    t.text     "stateReason"
    t.text     "tagSet"
    t.text     "blockDeviceMapping"
    t.string   "privateDnsName"
    t.string   "dnsName"
    t.string   "subnetId"
    t.string   "vpcId"
    t.string   "privateIpAddress"
    t.string   "ipAddress"
    t.string   "rootDeviceType"
    t.string   "rootDeviceName"
    t.string   "virtualizationType"
    t.string   "networkInterfaceId"
    t.string   "attachmentId"
    t.string   "ebsOptimized"
    t.datetime "launchTime"
    t.string   "reason"
    t.integer  "nodemap_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["dnsName"], name: "index_ec2s_on_dnsName"
    t.index ["imageId"], name: "index_ec2s_on_imageId"
    t.index ["instanceId"], name: "index_ec2s_on_instanceId"
    t.index ["instanceType"], name: "index_ec2s_on_instanceType"
    t.index ["ipAddress"], name: "index_ec2s_on_ipAddress"
    t.index ["nodemap_id"], name: "index_ec2s_on_nodemap_id"
    t.index ["ownerId"], name: "index_ec2s_on_ownerId"
    t.index ["privateDnsName"], name: "index_ec2s_on_privateDnsName"
    t.index ["privateIpAddress"], name: "index_ec2s_on_privateIpAddress"
    t.index ["reason"], name: "index_ec2s_on_reason"
  end

  create_table "nodemaps", force: :cascade do |t|
    t.string   "role"
    t.string   "environment"
    t.string   "name"
    t.string   "instanceState"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "subnets", force: :cascade do |t|
    t.string   "subnet_id"
    t.string   "state"
    t.string   "vpc_id"
    t.string   "cidr_block"
    t.integer  "available_ip_address_count"
    t.string   "availability_zone"
    t.string   "tag_set"
    t.boolean  "map_public_ip_on_launch"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["availability_zone"], name: "index_subnets_on_availability_zone"
    t.index ["subnet_id"], name: "index_subnets_on_subnet_id"
    t.index ["vpc_id"], name: "index_subnets_on_vpc_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
