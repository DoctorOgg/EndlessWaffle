class SecurityGroup < ApplicationRecord
  serialize :ip_permissions, JSON
  serialize :ip_permissions_egress, JSON
  serialize :tags, JSON
end
