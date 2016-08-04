class ApiKey < ApplicationRecord
  before_create :generate_access_token
  validates :user, presence: true

  def reset
    self.access_token = SecureRandom.hex
  end
  
private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
