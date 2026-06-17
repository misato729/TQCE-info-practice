Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :health, only: :show, controller: :health
    end
  end
end
