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

ActiveRecord::Schema.define(version: 20160822164054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ami_instance_type_matrices", force: :cascade do |t|
    t.string   "family"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "virtualization_engine"
    t.string   "storage_engine"
  end

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
    t.index ["aki_id"], name: "index_amis_on_aki_id", using: :btree
    t.index ["ami_id"], name: "index_amis_on_ami_id", using: :btree
    t.index ["availability_zone"], name: "index_amis_on_availability_zone", using: :btree
    t.index ["name"], name: "index_amis_on_name", using: :btree
    t.index ["version"], name: "index_amis_on_version", using: :btree
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.boolean  "admin",        default: false
    t.string   "user"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token", using: :btree
  end

  create_table "buildlogs", force: :cascade do |t|
    t.string   "uuid"
    t.text     "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_buildlogs_on_uuid", using: :btree
  end

  create_table "commands", force: :cascade do |t|
    t.string   "name"
    t.text     "command"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_commands_on_name", using: :btree
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
    t.index ["dnsName"], name: "index_ec2s_on_dnsName", using: :btree
    t.index ["imageId"], name: "index_ec2s_on_imageId", using: :btree
    t.index ["instanceId"], name: "index_ec2s_on_instanceId", using: :btree
    t.index ["instanceType"], name: "index_ec2s_on_instanceType", using: :btree
    t.index ["ipAddress"], name: "index_ec2s_on_ipAddress", using: :btree
    t.index ["nodemap_id"], name: "index_ec2s_on_nodemap_id", using: :btree
    t.index ["ownerId"], name: "index_ec2s_on_ownerId", using: :btree
    t.index ["privateDnsName"], name: "index_ec2s_on_privateDnsName", using: :btree
    t.index ["privateIpAddress"], name: "index_ec2s_on_privateIpAddress", using: :btree
    t.index ["reason"], name: "index_ec2s_on_reason", using: :btree
  end

  create_table "nodemaps", force: :cascade do |t|
    t.string   "role"
    t.string   "environment"
    t.string   "name"
    t.string   "instanceState"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "provision_job_data", force: :cascade do |t|
    t.string   "arguments"
    t.string   "environment"
    t.string   "role"
    t.string   "name"
    t.text     "log"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "uuid"
    t.string   "status"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "provision_command"
    t.string   "terminate_command"
    t.text     "environments"
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "security_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "group_id"
    t.string   "ip_permissions"
    t.string   "ip_permissions_egress"
    t.string   "owner_id"
    t.string   "vpc_id"
    t.string   "tags"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["group_id"], name: "index_security_groups_on_group_id", using: :btree
    t.index ["name"], name: "index_security_groups_on_name", using: :btree
    t.index ["vpc_id"], name: "index_security_groups_on_vpc_id", using: :btree
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
    t.index ["availability_zone"], name: "index_subnets_on_availability_zone", using: :btree
    t.index ["subnet_id"], name: "index_subnets_on_subnet_id", using: :btree
    t.index ["vpc_id"], name: "index_subnets_on_vpc_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vpcs", force: :cascade do |t|
    t.string   "vpc_id"
    t.string   "state"
    t.string   "cidr_block"
    t.string   "dhcp_options_id"
    t.string   "tags"
    t.string   "tenancy"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["vpc_id"], name: "index_vpcs_on_vpc_id", using: :btree
  end

end
