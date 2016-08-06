class AmiController < ApplicationController
  # before_action :restrict_access

  def update
    UpdateUbuntuAmiJob.perform_later
    render :json => {:message => "request subbmited"}
  end

  def show
    # Rails.logger.info params.inspect
    @query = Ami.all
    if params.key? :query
      @query = @query.where(availability_zone: params[:query][:availability_zone]) if params[:query].key? :availability_zone
      @query = @query.where(name: params[:query][:name]) if params[:query].key? :name
      @query = @query.where(version: params[:query][:version]) if params[:query].key? :version
      @query = @query.where(arch: params[:query][:arch]) if params[:query].key? :arch
      @query = @query.where(instance_type: params[:query][:instance_type]) if params[:query].key? :instance_type
      @query = @query.where(release: params[:query][:release]) if params[:query].key? :release
      @query = @query.where(ami_id: params[:query][:ami_id]) if params[:query].key? :ami_id
    end
    render :json => @query.order('availability_zone').order('version').to_json
  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end

end
