Rails.application.routes.draw do
  get "job", to: "application#execute_job"
  get "admin/credentials", to: "administration#get_credentials"
  get "termos-de-uso", to: "policy#terms_of_use"
  get "politica-privacidade", to: "policy#privacy_policy"
  root to: "donates#index"
  resources :donates do
    get :checkout
    get :consult_payment
    post :checkout
  end
end
