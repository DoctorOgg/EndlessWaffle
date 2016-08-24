class SecuritygroupsController < ApplicationController
  before_action :restrict_access

  def show
    @query = SecurityGroup.all
    if params.key? :query
      @query = @query.where(name: params[:query][:name]) if params[:query].key? :name
      @query = @query.where(group_id: params[:query][:group_id]) if params[:query].key? :group_id
      @query = @query.where(vpc_id: params[:query][:vpc_id]) if params[:query].key? :vpc_id
    end
    render :json => @query.order('name').to_json
  end

  def update
    UpdateSecurityGroupsJob.perform_later(AWS_CONFIG)
    render :json => {:message => "request subbmited"}
  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end
end
