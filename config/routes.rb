Invoicing::Application.routes.draw do
  resources :codes


  resources :addresses


  resources :invoices

  resources :invoices do
    resources :lines, only: :destroy
  end

  resources :payments


  resources :contacts


  resources :accounts


  resources :lines


  resources :items


  root :to => "home#index"
  resources :users, :only => [:index, :show, :edit, :update ]
  match '/invoices/:id/email' => 'invoices#email'
  match '/invoices/:id/send_email' => 'invoices#send_email'
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'
end
