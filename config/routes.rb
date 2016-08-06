Rails.application.routes.draw do
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
