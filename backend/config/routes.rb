Rails.application.routes.draw do
  root "status#show"

  namespace :api do
    namespace :v1 do
      resource :health, only: :show, controller: :health
      post "auth/signup", to: "auth#signup"
      post "auth/login", to: "auth#login"
      resource :me, only: :show, controller: :me
      resources :exams, only: :index
      resources :answer_histories, only: %i[index show]

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
