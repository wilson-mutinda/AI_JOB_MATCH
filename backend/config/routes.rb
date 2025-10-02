Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # user
      post 'create_user', to: 'users#create_user'
      get 'single_user/:id', to: 'users#single_user'
      get 'all_users', to: 'users#all_users'
      patch 'update_user/:id', to: 'users#update_user'
      delete 'delete_user/:id', to: 'users#delete_user'

      # google login
      post 'google_login', to: 'users#google_login'

      post 'user_login', to: 'users#user_login'

      post 'refresh_token/', to: 'users#refresh_token'

      # recruiter
      post 'create_recruiter/', to: 'recruiters#create_recruiter'
      get 'single_recruiter/:id', to: 'recruiters#single_recruiter'
      get 'all_recruiters/', to: 'recruiters#all_recruiters'
      patch 'update_recruiter/:id', to: 'recruiters#update_recruiter'
      delete 'delete_recruiter/:id', to: 'recruiters#delete_recruiter'

      # candidate
      post 'create_candidate/', to: 'candidates#create_candidate'
      get 'single_candidate/:id', to: 'candidates#single_candidate'
      get 'all_candidates/', to: 'candidates#all_candidates'
      patch 'update_candidate/:id', to: 'candidates#update_candidate'
      delete 'delete_candidate/:id', to: 'candidates#delete_candidate'

      get 'posted_jobs', to: 'candidates#posted_jobs'
      
      # job
      post 'create_job/', to: 'jobs#create_job'
      get 'single_job/:id', to: 'jobs#single_job'
      get 'all_jobs', to: 'jobs#all_jobs'
      patch 'update_job/:id', to: 'jobs#update_job'
      delete 'delete_job/:id', to: 'jobs#delete_job'
      
      get 'job_candidates', to: 'jobs#job_candidates'

      # application
      post 'create_application', to: 'applications#create_application'
      get 'single_application/:id', to: 'applications#single_application'
      get 'all_applications', to: 'applications#all_applications'
      get 'all_my_applications', to: 'applications#all_my_applications'
      patch 'update_application/:id', to: 'applications#update_application'
      delete 'delete_application/:id', to: 'applications#delete_application'

      get 'candidate_applications', to: "applications#candidate_applications"

      get 'tailored_resume/:id', to: 'applications#tailored_resume'
      
    end
  end
end
