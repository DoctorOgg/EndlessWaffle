class Ec2 < ApplicationRecord
  belongs_to :nodemap
  serialize :networkInterfaces, JSON
  serialize :placement, JSON
  serialize :iamInstanceProfile, JSON
  serialize :instanceState, JSON
  serialize :monitoring, JSON
  serialize :productCodes, JSON
  serialize :stateReason, JSON
  serialize :tagSet, JSON
  serialize :blockDeviceMapping, JSON
end
