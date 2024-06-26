Rails.application.routes.draw do
  devise_for :users

  get "termos-de-uso", to: "policy#terms_of_use"
  get "politica-privacidade", to: "policy#privacy_policy"
  get "thanks", to: "donates#thanks"
  get "show_alerts", to: "alerts#show"
  root to: "donates#index"
  resources :donates do
    get :checkout
    get :consult_payment
    post :checkout
  end

  get "admin", to: "administration#index"
  get "admin/test_alert", to: "administration#send_test_alert"
  get "admin/audio/:file", to: "administration#get_file", as: "audio"
  namespace :admin do
    get "credentials", to: "administration#get_credentials"
  end
end
