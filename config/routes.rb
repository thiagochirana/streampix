Rails.application.routes.draw do
  root to: 'donates#index'
  resources :donates
end
