Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
    root to: 'pages#index'
    
    resources :publishers
    resources :authors
    resources :books
    resources :users
    resources :reviewerships, :only => [:index]
    resources :book_reviews, :only => [:index]
    resources :donations, :only => [:index, :create]
    
    post 'books/:id/post_review' => 'books#post_review'
    delete 'books/delete_review/:id' => 'books#delete_review'
    post 'users/req/:id' => 'users#req'
    
    post 'users/accept/:id', to: 'users#accept', as: 'accept'
    get 'users/reject/:id', to: 'users#reject', as: 'reject'
    
    post 'users/:id/post_review' => 'users#post_review'
    delete 'users/delete_review/:id' => 'users#delete_review'
    #post 'users/:id/feedback/', to: 'users#feedback', as: 'feedback'
    
    post 'reviewerships/approve/' => 'reviewerships#approve'
    post 'book_reviews/approve/' => 'book_reviews#approve'
    post '/users/donations' => 'donations#create'
    post 'donations/accept/' => 'donations#accept'
    
    get '/secret', to: 'pages#secret', as: :secret
    
    get '/queries' => 'queries#index'
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
