Rails.application.routes.draw do
  root "status#show"

  namespace :api do
    namespace :v1 do
      resource :health, only: :show, controller: :health
      resources :exams, only: :index

      resources :questions, only: :show do
        collection do
          get :next
        end

        member do
          post :answer
        end
      end
    end
  end
end
