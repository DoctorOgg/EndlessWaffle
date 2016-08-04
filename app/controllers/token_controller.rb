class TokenController < ApplicationController
  before_action :restrict_access

  def get
    key = ApiKey.find_by user: @@user
    if key.nil?
      key = ApiKey.new
      key.user = @@user
      key.admin = true if User.adminUser? @@user
      key.save
    end
    render :json => {:token => key.access_token}
  end

  def reset
    key = ApiKey.find_by user: @@user
    if key.nil?
      key = ApiKey.new
      key.user = @@user
      key.admin = true if User.adminUser? @@user
      key.save
    end
    key.reset
    key.save
    render :json => {:token => key.access_token}
  end

  private
  def restrict_access
    authenticate_or_request_with_http_basic do |user, password|
      result = User.authenticate(user,password)
      if result
        @@user=user
      end
      result
    end
  end


end
