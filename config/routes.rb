Rails.application.routes.draw do
  root to: "static_pages#root"
  resources :devices, only: :index

  get "devices/today", to: "devices#today"
  get "devices/three", to: "devices#three_days"
  get "devices/seven", to: "devices#seven_days"
  get "devices/fourteen", to: "devices#fourteen_days"
end
