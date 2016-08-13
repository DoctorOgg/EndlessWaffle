class Vpc < ApplicationRecord
  serialize :tags, JSON
end
