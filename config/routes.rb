Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post 'ec2terminateC/terminate'


  post 'role/create'
  post 'role/update'
  post 'role/show'
  post 'role/list'
  post 'role/delete'

  post 'commands/create'
  post 'commands/update'
  post 'commands/show'
  post 'commands/list'
  post 'commands/delete'

  get 'ec2provision/showjobs'
  post 'ec2provision/showjobs'
  post 'ec2provision/show'
  get 'ec2provision/show/:uuid' => 'ec2provision#show'

  get 'ec2provision/build'
  post 'ec2provision/build'
  get 'ec2provision/watchjob/:uuid' => 'ec2provision#watchjob'

  get 'vpc/show'
  get 'vpc/update'

  get 'securitygroups/show'
  post 'securitygroups/show'
  get 'securitygroups/update'

  get 'token/get'
  get 'token/reset'

  get 'subnets/show', to: "subnets#show"
  post 'subnets/show', to: "subnets#show"
  get 'subnets/update'

  get 'ami/show', to: "ami#show"
  post 'ami/show', to: "ami#show"
  get 'ami/update'

  get "/ec2/update", to: "ec2#update"
  get "/ec2", to: "ec2#show"
  post "/ec2", to: "ec2#show"

end
