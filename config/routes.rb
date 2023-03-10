Rails.application.routes.draw do
  namespace :v1 do
    resources :users
    resources :student_profiles
    resources :learning_paths
    resources :author_profiles
    resources :courses do
      post 'enroll', on: :member
      post 'complete', on: :member
    end
  end
end
