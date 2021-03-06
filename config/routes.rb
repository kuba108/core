Shoppe::Engine.routes.draw do
  
  get 'attachment/:id/:filename.:extension' => 'attachments#show'
  resources :product_categories
  resources :products do
    resources :variants
  end

  get '/smazat-fotku/:id/:photo_id', :to => 'products#delete_photo', :as => 'delete_photo'
  get '/galerie/smazat-fotku/:id/:photo_id', :to => 'gallery_categories#delete_photo', :as => 'delete_gallery_photo'

  resources :orders do
    post :search, :on => :collection
    post :accept, :on => :member
    post :reject, :on => :member
    post :ship, :on => :member
    get :despatch_note, :on => :member
    resources :payments, :only => [:create, :destroy] do
      match :refund, :on => :member, :via => [:get, :post]
    end
  end
  resources :stock_level_adjustments, :only => [:index, :create]
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :tax_rates
  resources :gallery_categories do
    get 'show-on-homepage', to: 'gallery_categories#show_on_homepage', on: :member
  end
  resources :gallery_photos
  resources :users
  resources :countries
  resources :attachments, :only => :destroy

  get 'settings'=> 'settings#edit'
  post 'settings' => 'settings#update'
  
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'login/reset' => 'sessions#reset', :via => [:get, :post]
  
  delete 'logout' => 'sessions#destroy'
  root :to => 'dashboard#home'
end
