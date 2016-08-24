class SubnetsController < ApplicationController
  before_action :restrict_access
  def update
    UpdatesubnetsJob.perform_later(AWS_CONFIG)
    render :json => {:message => "request subbmited"}
  end

  def show
    # Rails.logger.info params.inspect
    @query = Subnet.all
    if params.key? :query
      @query = @query.where(availability_zone: params[:query][:availability_zone]) if params[:query].key? :availability_zone
      @query = @query.where(subnet_id: params[:query][:subnet_id]) if params[:query].key? :subnet_id
      @query = @query.where(vpc_id: params[:query][:vpc_id]) if params[:query].key? :vpc_id
    end
    render :json => @query.order('availability_zone').to_json
  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end
end
