Rails.application.routes.draw do
  get 'questions/index'
  root 'questions#index'
  get '/fetch_question', to: 'questions#fetch_question'
  post '/evaluate_speech', to: 'questions#evaluate_speech'
end
