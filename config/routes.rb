Rails.application.routes.draw do
  resources :messages, module: 'chatroom'
  resources :documents
  resources :books
  resources :users
  resources :rooms, only: [:index, :new, :create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]

  get "/login" => "sessions#new", as: :login
  delete "/logout" => "sessions#destroy", as: :logout
  get "/guest_login" => "sessions#guest", as: :guest_login

  root to: "home#home"
  get "/add_file_to_book/:id" => "books#update"

  get "/admin_root" => "home#admin_home", as: :admin_root

  post "/update_location" => "users#updateLocation"
  get "/user_info" => "users#userInfo"
  post "/fetch_files_in_book" => "books#fetch_book_files"

  #override messages resource routes
  get "/messages/rooms/:room_id"=> "chatroom/messages#index", as: :room_messages

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
end
