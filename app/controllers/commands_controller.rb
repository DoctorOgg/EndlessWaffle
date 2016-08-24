class CommandsController < ApplicationController
  before_action :restrict_access

  def create
    if params.key? :name
      r = Command.new
      r.name = params[:name]
      render :json => { "result" => r.save }
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  def update
    if params.key? :name and params.key? :command
      r = Command.where(name: params[:name]).first
      r.name = params[:name]
      r.command = params[:command]
      render :json => { "result" => r.save }
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  def show
    if params.key? :name
      r = Command.where(name: params[:name]).first
      render json: r, :only => [:name, :command ]
    else
      render :json =>  { :error => "You must provide a name"}
    end
  end

  def list
    if params.key? :query
      @query = Command.all
      @query = @query.where(name: params[:query][:name]) if params[:query].key? :name
      render :json => @query.order("name"), :only => [:name, :created_at,:updated_at]
    else
      render :json => Command.all.order("name"), :only => [:name, :created_at,:updated_at]
    end
  end

  def delete
    if params.key? :name
      r = Command.where(name: params[:name]).first
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
