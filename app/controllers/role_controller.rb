class RoleController < ApplicationController
  require 'pty'

  before_action :restrict_access

  def create
    if params.key? :name
      r = Role.new
      r.name = params[:name]
      render :json => { "result" => r.save }
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  def update
    if params.key? :name and params.key? :environments
      r = Role.where(name: params[:name]).first
      r.name = params[:name]
      r.environments = params[:environments]
      r.provision_command = params[:provision_command]
      r.terminate_command = params[:terminate_command]
      render :json => { "result" => r.save }
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  def show
    if params.key? :name
      r = Role.where(name: params[:name]).first
      render json: r, :only => [:name, :environments, :provision_command, :terminate_command]
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  def list
    if params.key? :query
      @query = Role.all
      @query = @query.where(name: params[:query][:name]) if params[:query].key? :name
      render :json => @query.order("name"), :only => [:name, :created_at,:updated_at]
    else
      render :json => Role.all.order("name"), :only => [:name, :created_at,:updated_at]
    end
  end

  def delete
    if params.key? :name
      r = Role.where(name: params[:name]).first
      render json: r.delete
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.where(access_token: token).where(admin: true).first
    end
  end
end
