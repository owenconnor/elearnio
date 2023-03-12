Rails.application.routes.draw do
  resources :users
  resources :student_profiles
  resources :learning_paths do
    post 'subscribe', on: :member
  end
  resources :author_profiles
  resources :courses do
    post 'enroll', on: :member
    post 'complete', on: :member
  end
end
