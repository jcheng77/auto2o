# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".

# You can have the root of your site routed with "root"
# root 'welcome#index'

# Example of regular route:
#   get 'products/:id' => 'catalog#view'

# Example of named route that can be invoked with purchase_url(id: product.id)
#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

# Example resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Example resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Example resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end

# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
Rails.application.routes.draw do

  resources :feedbacks

  resources :comments

  resources :cities

  resources :shops

  get 'dealers/register'

  get 'users/register'

  get 'dealers/index'

  get 'dealers/show'

  root to: 'home#index'
  get 'home', to: 'home#index'
  get 'home/introduction', to: 'home#introduction'
  get 'home/download', to: 'home#download'
  get 'home/about', to: 'home#about'
  get 'home/join', to: 'home#join'
  get 'home/faq', to: 'home#faq'


  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  devise_for :dealers
  devise_for :users

  devise_scope :dealer do
      get "dealers/sign_out", to: "devise/sessions#destroy"
  end


  resources :devices

  resources :deposits, only: [:create, :update] do
    collection do
      post :alipay_app_notify
      get :amount_and_discount
    end
  end


  resources :deals do
    member do
      get :qrcode
      get :verify
      get :show_for_dealer
    end
  end

  resources :dealers do
    collection do
      post :register
      post :reset_pwd
    end
    member do
      post :checkin
    end
  end

  resources :users do
    collection do
      post :register
      post :reset_pwd
    end
  end

  resources :bargains do
    member do
      post :submit
    end
  end

  resources :bids do
    member do
      post :accept_final
      post :accept
    end
  end

  resources :tenders do
    member do
      post :invite
      get :bid
      patch :cancel
      put :confirm
      delete :cancel_1_round
      post :submit
      get :bids_list
      post :submit_bargain
      get :show_bargain
      get :bargain
      get :bid_final
      post :submit_2_round
      get :final_bids
      delete :cancel_2_round
      # for debug:
      get :finish_1st_round
      get :finish_2nd_round
    end
    collection do
      get :dealer_index
      get :update_model
      post :update_trim
      post :update_shops
    end
  end

  resources :cars do
    collection do
      get :list
      get :trims
    end
  end


end
