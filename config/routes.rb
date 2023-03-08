Rails.application.routes.draw do
  namespace :v1 do
    resources :student_profiles
    resources :learning_paths
    resources :author_profiles
    resources :courses
  end
end
