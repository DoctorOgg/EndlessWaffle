class UpdateUbuntuAmiJob < ApplicationJob
  require "open-uri"
  queue_as :default

  def perform(*args)
    url = "http://cloud-images.ubuntu.com/locator/ec2/releasesTable"
    json_string = open(url).read
    json_string.slice!(-6)
    collection = JSON.load(json_string)["aaData"]
    collection.each do |i|
      ami_id = i[6][/.*>(ami\-\w{8})<.*/, 1]
      release = i[5].to_i
      arch = i[3]
      version = i[2]
      if arch != 'i386' and !version.include?('EOL')
        if Ami.where(ami_id: ami_id).where(release: release).exists?
          record = Ami.where(ami_id: ami_id).where(release: release).first
        else
          record = Ami.new
        end

        record.availability_zone =  i[0]
        record.name = i[1]
        record.version = version
        record.arch = arch
        record.instance_type = i[4]
        record.release = release
        record.ami_id = ami_id
        record.aki_id = i[7]
        record.save
      end
    end
  end
end

# a = Ami.where(arch: "amd64").where(availability_zone: "us-east-1").where(version: '16.04 LTS').where(instance_type: 'ebs-ssd').order(release: :desc).first
