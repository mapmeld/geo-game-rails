GeoGameRails::Application.routes.draw do

  # utility pages
  match "/refresh_photos" => "home#refresh_photos"

  # dynamic pages
  match "/category/:tag" => "category#show"
  match "/leaderboard" => "instagram_user#index"
  match "/user/:username" => "instagram_user#show"

  # info pages
  get "/start" => "home#start"
  get "/scoring" => "home#scoring"
  get "/about" => "home#about"

  root :to => "home#index"
  
end