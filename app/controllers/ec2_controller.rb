class Ec2Controller < ApplicationController
  before_action :restrict_access

  def update
    UpdateEc2Job.perform_later
    render :json => {:message => "request subbmited"}
  end

  def show
    if params.key? :query
      @query = Ec2.joins(:nodemap)
      @query = @query.where("nodemaps.name = ?", params[:query][:name]) if params[:query].key? :name
      @query = @query.where("nodemaps.role = ?", params[:query][:role])  if params[:query].key? :role
      @query = @query.where("nodemaps.environment = ?", params[:query][:environment]) if params[:query].key? :environment
      @query = @query.where("instanceId = ?", params[:query][:instanceId]) if params[:query].key? :instanceId
      @query = @query.where("nodemaps.instanceState = ?", params[:query][:instanceState]) if params[:query].key? :instanceState
      render :json => @query.order("nodemaps.environment").order("nodemaps.role").order("nodemaps.name").to_json(:include => :nodemap)
    else
      render :json => Ec2.joins(:nodemap).where("nodemaps.instanceState != 'terminated'").order("nodemaps.environment").order("nodemaps.role").order("nodemaps.name").to_json(:include => :nodemap)
    end

  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end

end
