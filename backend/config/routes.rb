Rails.application.routes.draw do
  root "status#show"

  namespace :api do
    namespace :v1 do
      resource :health, only: :show, controller: :health
    end
  end
end
