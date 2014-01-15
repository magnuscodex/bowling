RailsBootstrap::Application.routes.draw do
  root :to => 'visitors#new'
  match '/pages/score_card', :to => 'score_card#new', :via => [:get, :post]
end
