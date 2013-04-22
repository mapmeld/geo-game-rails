MicroBoundaries::Application.routes.draw do

  # utility pages
  match "/refresh_photos" => "home#refresh_photos"

  # dynamic pages
  match "/microbe/:id" => "microbe#show"
  match "/leaderboard" => "instagram_user#index"
  match "/user/:id" => "instagram_user#show"

  # info pages
  get "/start" => "home#start"
  get "/scoring" => "home#scoring"

  root :to => "home#index"
  
end