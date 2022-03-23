Rails.application.routes.draw do

  devise_for :admin, controllers: {
   sessions: "admin/sessions"
  }

  namespace :admin do
    get '/' => 'homes#top'
    resources :items, except: [:destroy]
    resources :genres, except: [:destroy, :new, :show]
    resources :customers, only: [:index, :show, :edit, :update] 
   # resources :orders, only: [:index]
    resources :orders, only: [:show, :update]
    resources :order_details, only: [:update]
  end
  
  scope module: :public do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :items, only: [:index, :show] 
    resource :customers, only: [:edit, :update] 
    get 'customers/my_page' => 'customers#show'
    get 'customers/unsubscribe' => 'customers#unsubscribe'
    patch 'customers/withdraw' => 'customers#withdraw'
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all'
    resources :cart_items, only: [:index, :destroy, :create, :update] 
    post 'orders/confirm' => 'orders#confirm'
    get 'orders/thanks' => 'orders#thanks'
    resources :orders, only: [:new, :create, :index, :show] 
    resources :addresses, only: [:index, :edit, :create, :update, :destroy] 
  end
  
   devise_for :customers, controllers: {
   sessions: "public/sessions",
   registrations: "public/registrations"
  }
end