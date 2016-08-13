class Role < ApplicationRecord
  serialize :environments, JSON
  after_initialize :init
  validates :name, presence: true

    def init
      self.environments ||= {
        "dev1" => {
          "ami" => {  "version" => "16.04 LTS",
                      "instance_type" => "ebs-ssd",
                      "disk_size" => 10,
                      "instance_size"=> "t2.small",
                      "ssh_user" => "ubuntu"
                    },
          "security_groups" => ["default"],
          "ssh_key_name" => "ops",
          "ssh_key_path" => "ssh/oun-ops.pem",
          "chef_role" => "idr"
        },
        "dev2" => {
          "ami" => {  "ami_id": "ami-xxxxxx",
                      "disk_size" => 10,
                      "instance_size"=> "t2.small",
                      "ssh_user" => "ubuntu"
                    },
          "security_groups" => ["default"],
          "ssh_key_name" => "ops",
          "ssh_key_path" => "ssh/oun-ops.pem",
          "chef_role" => "idr"
        }
      }
    end
end
