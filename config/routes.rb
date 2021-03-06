Invoicing::Application.routes.draw do
  resources :settings


  resources :email_records


  resources :email_templates


  resources :codes


  resources :addresses


  resources :invoices

  resources :invoices do
    resources :lines, only: :destroy
    collection do
      post :edit_multiple
    end
  end


  resources :payments

  resources :payments do
    collection do
        post :import
    end
  end



  resources :contacts


  resources :accounts do
    collection do
      post :import
    end
  end


  resources :lines


  resources :items do
    collection do
      post :import
    end
    collection do
      post :edit_multiple
    end

  end

  root :to => "invoices#index"
  resources :users

  match '/import' => 'static_pages#import'
  match '/home' => 'static_pages#home'
  match '/accounts/:account_id/invoices/new' => 'invoices#new', :as => "new_account_invoice"
  match '/accounts/:id/contacts/new' => 'contacts#new', :as => "new_account_contact"
  match '/accounts/:account_id/payments/new' => 'payments#new', :as => "new_account_payment"

  match '/invoices/:id/payments/new' => 'payments#new', :as => "new_invoice_payment"
  match '/invoices/:id/build' => 'invoices#build'
  match '/invoices/:id/email' => 'invoices#email'
  match '/invoices/:id/send_email' => 'invoices#send_email'
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signin/google' => 'sessions#new', :provider => 'google_oauth2'
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'
end
