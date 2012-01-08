Hapful::Application.routes.draw do
  

  get "user_payment_methods/index"

  get "user_payment_methods/new"

  get "user_payment_methods/edit"

  get "paypal_accounts/index"

  get "paypal_accounts/edit"

  namespace :admin do 
    resources :categories
    resources :articles
    resources :payment_types
    resources :shipping_options
    resources :project_configs
    resources :users
    root :to => 'dashboard#index'
  end

  
  devise_for :users do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  resources :users do
    member do
      get :change_password
      post :update_password
      get :merchant_detail
      match :update_merchant_detail
    end
    resources :user_merchant_accounts, :path=>:merchaccounts
    resources :user_payment_methods, :path=>:paygates
  end

  resources :products do
    resources :product_widgets do
      member do
        get :preview
        get :iframed
      end
    end
    member do
      get :demo
    end
  end

  resources :orders

  match '/my-dashboard' => 'users#dashboard', :as=>:user_dashboard

  match '/add-to-cart/:product_slug' =>'carts#add',   :as=>:add_to_cart
  match '/my-cart'                    =>'carts#show', :as=>:show_cart

  match  '/checkout/payment_state/:state'=> 'payments#set_state',               :as=>:set_payment_state
  match '/checkout/notice'            => 'payments#manual',                     :as=>:payment_notice
  get   '/checkout/payment'           => 'payments#new',                      :as=>:payment_checkout
  post  '/checkout/payment'           => 'payments#create',                   :as=>:do_payment_checkout
  get   '/checkout/complete_ppexpress'=> 'payments#complete_paypal_express',  :as=>:complete_paypal_express
  get   '/checkout/:merchant'         => 'orders#new',                        :as=>:checkout
  post  '/checkout/:merchant'         => 'orders#create',                     :as=>:build_order

  match '/market' => 'pages#market', :as=>:market
  match '/complete' => 'orders#completed', :as=>:completed_order
 
  match '/paypal-express' => 'payments#paypal_express', :as=>:paypal_express_checkout
  match '/p/:id' => 'products#show'

  #  scope :protocol => 'https://', :constraints => { :protocol => 'https://' } do
  #    match '/paypal-express' => 'payments#paypal_express', :as=>:paypal_express_checkout
  #  end
  
  root :to=>'pages#index'

end
