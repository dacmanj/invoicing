Invoicing::Application.routes.draw do
  resources :codes


  resources :addresses


  resources :invoices


  resources :payments


  resources :contacts


  resources :accounts


  resources :lines


  resources :items


  root :to => "home#index"
  resources :users, :only => [:index, :show, :edit, :update ]
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'
end
