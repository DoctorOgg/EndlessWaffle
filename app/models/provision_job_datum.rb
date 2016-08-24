class ProvisionJobDatum < ApplicationRecord
  # enum status: { queued: 1, running: 2, completed: 3, failed: 4 }
  serialize :log, Array
end
