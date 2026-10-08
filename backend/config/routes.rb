Rails.application.routes.draw do
  root "status#show"

  namespace :api do
    namespace :v1 do
      resource :health, only: :show, controller: :health
      post "auth/signup", to: "auth#signup"
      post "auth/login", to: "auth#login"
      resource :me, only: %i[show destroy], controller: :me
      resources :exams, only: :index
      resources :answer_histories, only: %i[index show]
      resources :favorites, only: :index
      put "questions/:question_id/favorite", to: "favorites#create", as: :question_favorite
      delete "questions/:question_id/favorite", to: "favorites#destroy"

      namespace :payments do
        resource :config, only: :show, controller: :config
        resources :checkout_sessions, only: :create
      end

      namespace :webhooks do
        post :stripe, to: "stripe#create"
      end

      resources :questions, only: :show do
        collection do
          get :next
        end

        member do
          post :answer
        end
      end

      namespace :admin do
        resources :questions, only: %i[index show create update destroy]
      end
    end
  end
end
