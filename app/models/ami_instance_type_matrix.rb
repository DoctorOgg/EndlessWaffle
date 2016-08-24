class AmiInstanceTypeMatrix < ApplicationRecord
  # Source: https://aws.amazon.com/amazon-linux-ami/instance-type-matrix/
  # enum virtualization_engine: { pv: 1, hvm: 2 }
  # enum storage_engine: { instance: 1, ebs: 2 }
end
