Rails.application.routes.draw do
  get 'token/get'
  get 'token/reset'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :ec2
  get "/ec2/update", to: "ec2#update"
  get "/ec2", to: "ec2#show"
  post "/ec2", to: "ec2#show"

end
