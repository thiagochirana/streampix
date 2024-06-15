Rails.application.routes.draw do
  get "admin/credentials", to: "administration#get_credentials"
  get "termos-de-uso", to: "policy#terms_of_use"
  get "politica-privacidade", to: "policy#privacy_policy"
  root to: "donates#index"
  resources :donates do
    get :checkout
    post :checkout
  end
end
